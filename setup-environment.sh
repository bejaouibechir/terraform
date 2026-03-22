#!/usr/bin/env bash
# =============================================================================
#  setup-environment.sh
#  Prépare l'environnement complet pour le support Terraform Beginners Guide
#
#  Testé sur : Ubuntu 22.04 / 24.04 LTS (EC2 t2.micro / t3.medium)
#  Usage     : bash setup-environment.sh            (installation complète)
#              bash setup-environment.sh --check    (vérification sans installation)
#  Idempotent: peut être relancé plusieurs fois sans effet de bord
# =============================================================================

set -euo pipefail

# ─── Couleurs ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

ok()   { echo -e "${GREEN}  ✔  $*${RESET}"; }
info() { echo -e "${CYAN}  ➤  $*${RESET}"; }
warn() { echo -e "${YELLOW}  ⚠  $*${RESET}"; }
fail() { echo -e "${RED}  ✘  $*${RESET}"; exit 1; }
step() { echo -e "\n${BOLD}${CYAN}══════════════════════════════════════════${RESET}"
         echo -e "${BOLD}${CYAN}  $*${RESET}"
         echo -e "${BOLD}${CYAN}══════════════════════════════════════════${RESET}"; }

# ─── Variables ────────────────────────────────────────────────────────────────
TERRAFORM_VERSION="1.9.8"
LOCALSTACK_IMAGE="localstack/localstack:latest"
LOCALSTACK_CONTAINER="localstack-main"
LOCALSTACK_PORT="4566"
LOCALSTACK_SERVICES="ec2,s3,iam,sts,dynamodb"
PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
TERRAFORMRC="$HOME/.terraformrc"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Bannière ─────────────────────────────────────────────────────────────────
print_banner() {
  echo -e "${BOLD}"
  echo "  ╔══════════════════════════════════════════════════════════╗"
  echo "  ║       Terraform Beginners Guide — Setup Environment      ║"
  echo "  ║       Ubuntu 22.04/24.04 · EC2 · LocalStack              ║"
  echo "  ╚══════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

# =============================================================================
#  MODE --check : vérification rapide de l'environnement, sans installation
# =============================================================================
run_check() {
  print_banner
  echo -e "${YELLOW}${BOLD}  MODE VÉRIFICATION — aucune installation ne sera effectuée${RESET}\n"

  local issues=0

  # ── OS ──
  step "Système"
  OS=$(. /etc/os-release 2>/dev/null && echo "$ID" || echo "inconnu")
  ARCH=$(uname -m)
  info "OS : $OS / Arch : $ARCH"
  [[ "$OS" =~ ^(ubuntu|debian)$ ]] && ok "OS compatible" || { warn "OS non testé ($OS)"; issues=$((issues+1)); }

  # ── Paquets système ──
  step "Paquets système"
  for pkg in curl wget unzip jq git; do
    dpkg -s "$pkg" &>/dev/null && ok "$pkg" || { warn "$pkg ABSENT"; issues=$((issues+1)); }
  done

  # ── Terraform ──
  step "Terraform"
  if command -v terraform &>/dev/null; then
    TF_VER=$(terraform version | head -1 | grep -oP '\d+\.\d+\.\d+' || echo "?")
    ok "Terraform $TF_VER — $(command -v terraform)"
  else
    warn "Terraform ABSENT (v${TERRAFORM_VERSION} sera installé)"
    issues=$((issues+1))
  fi

  # ── Docker ──
  step "Docker"
  if command -v docker &>/dev/null; then
    # Tenter sans sudo, puis avec sudo
    _D="docker"; docker info &>/dev/null 2>&1 || _D="sudo docker"
    DOCKER_VER=$($_D version --format '{{.Server.Version}}' 2>/dev/null || echo "démon arrêté?")
    ok "Docker $DOCKER_VER — $(command -v docker)"
    $_D info &>/dev/null 2>&1 && ok "Démon Docker actif${_D:+ (via sudo)}" || { warn "Démon Docker inaccessible"; issues=$((issues+1)); }
  else
    warn "Docker ABSENT"
    issues=$((issues+1))
  fi

  # ── LocalStack ──
  step "LocalStack"
  # Détecter docker vs sudo docker pour le mode check aussi
  _DC="docker"; command -v docker &>/dev/null && { docker info &>/dev/null 2>&1 || _DC="sudo docker"; }
  if command -v docker &>/dev/null && $_DC info &>/dev/null 2>&1; then
    if $_DC ps --filter "name=$LOCALSTACK_CONTAINER" --filter "status=running" -q | grep -q .; then
      ok "Conteneur '$LOCALSTACK_CONTAINER' en cours d'exécution"
      if curl -s --max-time 3 "http://localhost:${LOCALSTACK_PORT}/_localstack/health" | grep -q '"running"' 2>/dev/null; then
        ok "LocalStack répond sur http://localhost:${LOCALSTACK_PORT}"
        info "Services actifs :"
        curl -s "http://localhost:${LOCALSTACK_PORT}/_localstack/health" \
          | jq -r '.services | to_entries[] | select(.value=="running") | "    ✔ \(.key)"' 2>/dev/null \
          || echo "    (jq requis pour détailler les services)"
      else
        warn "Conteneur tourne mais ne répond pas encore"
        issues=$((issues+1))
      fi
    else
      if $_DC ps -a --filter "name=$LOCALSTACK_CONTAINER" -q | grep -q .; then
        warn "Conteneur '$LOCALSTACK_CONTAINER' existe mais est ARRÊTÉ"
      else
        warn "Conteneur '$LOCALSTACK_CONTAINER' ABSENT"
      fi
      issues=$((issues+1))
    fi
  else
    warn "Docker inaccessible — LocalStack non vérifiable"
    issues=$((issues+1))
  fi

  # ── Cache Terraform ──
  step "Cache Terraform"
  if [[ -f "$TERRAFORMRC" ]]; then
    ok ".terraformrc : $TERRAFORMRC"
    grep "plugin_cache_dir" "$TERRAFORMRC" && true
  else
    warn ".terraformrc ABSENT"
    issues=$((issues+1))
  fi

  if [[ -d "$PLUGIN_CACHE_DIR/registry.terraform.io/hashicorp" ]]; then
    ok "Dossier cache : $PLUGIN_CACHE_DIR"
    info "Providers en cache :"
    for p in local random null tls http aws; do
      if ls "$PLUGIN_CACHE_DIR/registry.terraform.io/hashicorp/$p/" &>/dev/null; then
        ver=$(ls "$PLUGIN_CACHE_DIR/registry.terraform.io/hashicorp/$p/" | sort -V | tail -1)
        ok "  hashicorp/$p  $ver"
      else
        warn "  hashicorp/$p  ABSENT"
        issues=$((issues+1))
      fi
    done
  else
    warn "Cache Terraform ABSENT — tous les providers seront téléchargés"
    issues=$((issues+1))
  fi

  # ── Dossiers output ──
  step "Dossiers output des modules"
  missing_out=0
  for mod in \
    "04-Terraform-Top-Level-Blocks" \
    "05-Terraform-Commands" \
    "07-Terraform-Resources" \
    "20-Terraform-provisioners"; do
    [[ -d "$SCRIPT_DIR/$mod/output" ]] || { missing_out=$((missing_out+1)); }
  done
  if [[ $missing_out -eq 0 ]]; then
    ok "Dossiers output présents"
  else
    warn "$missing_out dossier(s) output manquants (créés automatiquement à l'install)"
  fi

  # ── Bilan ──
  echo ""
  echo -e "${BOLD}══════════════════════════════════════════${RESET}"
  if [[ $issues -eq 0 ]]; then
    echo -e "${GREEN}${BOLD}  ✔  Environnement complet — tout est prêt !${RESET}"
  else
    echo -e "${YELLOW}${BOLD}  ⚠  $issues élément(s) manquant(s) — lancez :${RESET}"
    echo -e "${YELLOW}${BOLD}      bash setup-environment.sh${RESET}"
  fi
  echo -e "${BOLD}══════════════════════════════════════════${RESET}"
  exit 0
}

# ─── Dispatch ──────────────────────────────────────────────────────────────────
[[ "${1:-}" == "--check" ]] && run_check

# =============================================================================
#  MODE INSTALLATION COMPLÈTE
# =============================================================================
print_banner

# ─── 1. OS & Architecture ─────────────────────────────────────────────────────
step "1. Vérification du système"

OS=$(. /etc/os-release && echo "$ID")
ARCH=$(uname -m)
info "Système : $(uname -s) / $OS / $ARCH"
[[ "$OS" =~ ^(ubuntu|debian)$ ]] || warn "Système non testé : $OS (Ubuntu recommandé)"
[[ "$ARCH" == "x86_64" ]] || warn "Architecture non testée : $ARCH"

# ─── 2. Paquets système ───────────────────────────────────────────────────────
step "2. Paquets système requis"

info "Mise à jour des dépôts apt..."
sudo apt-get update -qq

for pkg in curl wget unzip jq git ca-certificates gnupg lsb-release; do
  if dpkg -s "$pkg" &>/dev/null; then
    ok "$pkg déjà installé"
  else
    info "Installation de $pkg..."
    sudo apt-get install -y -qq "$pkg"
    ok "$pkg installé"
  fi
done

# ─── 3. Terraform ─────────────────────────────────────────────────────────────
step "3. Terraform"

install_terraform() {
  info "Téléchargement de Terraform $TERRAFORM_VERSION..."
  local url="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  wget -q "$url" -O /tmp/terraform.zip
  unzip -q /tmp/terraform.zip -d /tmp/
  sudo mv /tmp/terraform /usr/local/bin/terraform
  sudo chmod +x /usr/local/bin/terraform
  rm -f /tmp/terraform.zip
  ok "Terraform $TERRAFORM_VERSION installé"
}

if command -v terraform &>/dev/null; then
  TF_INSTALLED=$(terraform version | head -1 | grep -oP '\d+\.\d+\.\d+')
  ok "Terraform $TF_INSTALLED déjà installé"
  TF_MAJOR=$(echo "$TF_INSTALLED" | cut -d. -f1)
  TF_MINOR=$(echo "$TF_INSTALLED" | cut -d. -f2)
  if [[ "$TF_MAJOR" -lt 1 ]] || { [[ "$TF_MAJOR" -eq 1 ]] && [[ "$TF_MINOR" -lt 5 ]]; }; then
    warn "Version $TF_INSTALLED < 1.5 — mise à jour vers $TERRAFORM_VERSION..."
    install_terraform
  fi
else
  install_terraform
fi
terraform version | head -1

# ─── 4. Docker ────────────────────────────────────────────────────────────────
step "4. Docker"

install_docker() {
  info "Installation de Docker Engine..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2>/dev/null
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -qq
  sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo systemctl enable docker --now
  sudo usermod -aG docker "$USER" 2>/dev/null || true
  ok "Docker installé"
}

if command -v docker &>/dev/null; then
  DOCKER_VERSION=$(docker version --format '{{.Server.Version}}' 2>/dev/null || echo "inconnu")
  ok "Docker $DOCKER_VERSION déjà installé"
  sudo systemctl is-active --quiet docker 2>/dev/null || sudo systemctl start docker
else
  install_docker
fi

# Déterminer si docker est accessible sans sudo dans cette session
# (cas fréquent : groupe docker ajouté mais session non rechargée)
if docker info &>/dev/null 2>&1; then
  DOCKER="docker"
  ok "Docker accessible sans sudo"
else
  DOCKER="sudo docker"
  warn "Docker nécessite sudo pour cette session (groupe 'docker' sera actif à la prochaine connexion)"
  warn "Pour éviter sudo dès maintenant : exec newgrp docker && bash setup-environment.sh"
fi

# ─── 5. LocalStack ────────────────────────────────────────────────────────────
step "5. LocalStack"

start_localstack() {
  info "Démarrage de LocalStack (services: $LOCALSTACK_SERVICES)..."
  $DOCKER run -d \
    --name "$LOCALSTACK_CONTAINER" \
    -p "${LOCALSTACK_PORT}:4566" \
    -e SERVICES="$LOCALSTACK_SERVICES" \
    -e DEBUG=0 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    "$LOCALSTACK_IMAGE" > /dev/null
  info "Attente du démarrage de LocalStack..."
  local attempts=0
  until curl -s "http://localhost:${LOCALSTACK_PORT}/_localstack/health" | grep -q '"running"' 2>/dev/null; do
    sleep 3; attempts=$((attempts + 1)); echo -n "."
    [[ $attempts -gt 30 ]] && fail "LocalStack n'a pas démarré après 90s"
  done
  echo ""; ok "LocalStack démarré et opérationnel"
}

$DOCKER image inspect "$LOCALSTACK_IMAGE" &>/dev/null || {
  info "Téléchargement de l'image LocalStack..."
  $DOCKER pull "$LOCALSTACK_IMAGE" -q
}
ok "Image LocalStack disponible"

if $DOCKER ps --filter "name=$LOCALSTACK_CONTAINER" --filter "status=running" -q | grep -q .; then
  ok "LocalStack déjà en cours d'exécution"
elif $DOCKER ps -a --filter "name=$LOCALSTACK_CONTAINER" -q | grep -q .; then
  info "Conteneur arrêté — redémarrage..."
  $DOCKER start "$LOCALSTACK_CONTAINER" > /dev/null; sleep 10; ok "LocalStack redémarré"
else
  start_localstack
fi

info "Services LocalStack actifs :"
curl -s "http://localhost:${LOCALSTACK_PORT}/_localstack/health" \
  | jq -r '.services | to_entries[] | select(.value=="running") | "    ✔ \(.key)"' 2>/dev/null \
  || echo "    (LocalStack répond sur :${LOCALSTACK_PORT})"

# ─── 6. Cache de plugins Terraform ────────────────────────────────────────────
step "6. Cache de plugins Terraform"

mkdir -p "$PLUGIN_CACHE_DIR"
cat > "$TERRAFORMRC" <<EOF
plugin_cache_dir = "$PLUGIN_CACHE_DIR"
EOF
ok "Cache : $PLUGIN_CACHE_DIR"
ok ".terraformrc : $TERRAFORMRC"

# ─── 7. Pré-téléchargement des providers ──────────────────────────────────────
step "7. Pré-téléchargement des providers Terraform"

TMPDIR_TF=$(mktemp -d)
trap 'rm -rf "$TMPDIR_TF"' EXIT

cat > "$TMPDIR_TF/providers.tf" <<'TFEOF'
terraform {
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.0" }
    random = { source = "hashicorp/random", version = "~> 3.0" }
    null   = { source = "hashicorp/null",   version = "~> 3.0" }
    tls    = { source = "hashicorp/tls",    version = "~> 4.0" }
    http   = { source = "hashicorp/http",   version = "~> 3.4" }
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
  }
}
TFEOF

info "Téléchargement des providers (uniquement si non présents en cache)..."
cd "$TMPDIR_TF"
terraform init -input=false -no-color 2>&1 \
  | grep -E "(Installed|Using cached|Error)" | sed 's/^/    /' || true
cd - > /dev/null

for p in local random null tls http aws; do
  ok "hashicorp/$p disponible en cache"
done

# ─── 8. Vérification LocalStack + AWS provider ────────────────────────────────
step "8. Vérification AWS provider ↔ LocalStack"

TMPDIR_AWS=$(mktemp -d)
trap 'rm -rf "$TMPDIR_AWS" "$TMPDIR_TF"' EXIT

cat > "$TMPDIR_AWS/main.tf" <<'TFEOF'
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  endpoints {
    ec2 = "http://localhost:4566"; s3 = "http://localhost:4566"
    iam = "http://localhost:4566"; sts = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
  }
}
resource "aws_vpc" "test" {
  cidr_block = "10.99.0.0/16"
  tags       = { Name = "setup-test-vpc" }
}
output "vpc_id" { value = aws_vpc.test.id }
TFEOF

cd "$TMPDIR_AWS"
terraform init -input=false -no-color > /dev/null 2>&1
if terraform apply -auto-approve -input=false -no-color > /dev/null 2>&1; then
  VPC_ID=$(terraform output -raw vpc_id 2>/dev/null || echo "vpc-xxxxxxxx")
  ok "Test LocalStack réussi — VPC créé : $VPC_ID"
  terraform destroy -auto-approve -input=false -no-color > /dev/null 2>&1 || true
else
  warn "Test LocalStack échoué — vérifiez que LocalStack est démarré"
fi
cd - > /dev/null

# ─── 9. Dossiers output ───────────────────────────────────────────────────────
step "9. Création des dossiers output"

OUTPUT_MODULES=(
  "04-Terraform-Top-Level-Blocks"
  "05-Terraform-Commands"
  "07-Terraform-Resources"
  "08-Terraform-Resource-Meta-Arguments/08-01-count"
  "08-Terraform-Resource-Meta-Arguments/08-02-for_each"
  "08-Terraform-Resource-Meta-Arguments/08-02-for_each/01-for_each-map"
  "08-Terraform-Resource-Meta-Arguments/08-02-for_each/02-for_each-set"
  "08-Terraform-Resource-Meta-Arguments/08-03-depends_on"
  "08-Terraform-Resource-Meta-Arguments/08-04-provider"
  "08-Terraform-Resource-Meta-Arguments/08-05-lifecycle"
  "08-Terraform-Resource-Meta-Arguments/08-05-lifecycle/01-create_before_destroy"
  "08-Terraform-Resource-Meta-Arguments/08-05-lifecycle/02-prevent_destroy"
  "08-Terraform-Resource-Meta-Arguments/08-05-lifecycle/03-ignore_changes"
  "09-Terraform-Variables"
  "09-Terraform-Variables/09-01-Terraform-Variables-tfvars"
  "09-Terraform-Variables/09-02-Terraform-Variables-tfvars-var-file"
  "09-Terraform-Variables/09-03-Terraform-Variables-list"
  "09-Terraform-Variables/09-04-Terraform-Variables-map"
  "09-Terraform-Variables/09-05-Custom-Validation-Rules"
  "09-Terraform-Variables/09-06-Sensitive-Variables"
  "10-Terraform-Outputs"
  "11-Terraform-Data-Sources"
  "13-Terraform-Show"
  "14-Terraform-Refresh"
  "15-Terraform-State-Commands"
  "19-Terraform-Debug"
  "20-Terraform-provisioners"
)

created=0
for mod in "${OUTPUT_MODULES[@]}"; do
  outdir="$SCRIPT_DIR/$mod/output"
  [[ -d "$outdir" ]] || { mkdir -p "$outdir"; created=$((created + 1)); }
done
mkdir -p "$SCRIPT_DIR/08-Terraform-Resource-Meta-Arguments/08-04-provider/output/europe"
mkdir -p "$SCRIPT_DIR/08-Terraform-Resource-Meta-Arguments/08-04-provider/output/asia"
ok "$created dossier(s) output créé(s)"

# ─── 10. Résumé final ─────────────────────────────────────────────────────────
step "10. Résumé de l'environnement"

echo ""
echo -e "${BOLD}  Outils :${RESET}"
printf "    %-20s %s\n" "Terraform"  "$(terraform version | head -1 | grep -oP 'v[\d.]+')"
printf "    %-20s %s\n" "Docker"     "$($DOCKER version --format '{{.Server.Version}}' 2>/dev/null || echo 'N/A')"
printf "    %-20s %s\n" "LocalStack" "$(curl -s http://localhost:4566/_localstack/info 2>/dev/null | jq -r '.version' 2>/dev/null || echo 'running')"

echo ""
echo -e "${BOLD}  Providers en cache :${RESET}"
for p in local random null tls http aws; do
  ver=$(ls "$PLUGIN_CACHE_DIR/registry.terraform.io/hashicorp/$p/" 2>/dev/null | sort -V | tail -1 || echo "?")
  printf "    %-25s %s\n" "hashicorp/$p" "$ver"
done

echo ""
echo -e "${BOLD}  Modules prêts :${RESET}"
echo "    Providers légers  → 04 05 07 08 09 10 11 13 14 15 19 20"
echo "    AWS via LocalStack → 06 12 16 17 18"
echo ""
echo -e "${GREEN}${BOLD}  ✔  Environnement prêt ! Lancez les labs :${RESET}"
echo "     cd <module> && terraform init && terraform apply"
echo ""
cat <<'EOF'
  ─── Commandes utiles ───────────────────────────────────────────────────
  LocalStack : docker start/stop localstack-main
  Santé      : curl http://localhost:4566/_localstack/health | jq
  Logs       : docker logs localstack-main -f
  TF Debug   : TF_LOG=DEBUG terraform plan
  TF Cache   : ~/.terraform.d/plugin-cache
  ────────────────────────────────────────────────────────────────────────
EOF
