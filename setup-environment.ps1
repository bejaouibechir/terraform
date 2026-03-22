# =============================================================================
#  setup-environment.ps1
#  Prépare l'environnement Terraform Beginners Guide sur Windows
#
#  Prérequis : PowerShell 5.1+ / Windows 10+
#  Usage     : .\setup-environment.ps1
#  Idempotent: peut être relancé plusieurs fois sans effet de bord
# =============================================================================

$ErrorActionPreference = "Stop"

# ─── Couleurs ─────────────────────────────────────────────────────────────────
function ok($msg)   { Write-Host "  [OK]  $msg" -ForegroundColor Green }
function info($msg) { Write-Host "  [-->] $msg" -ForegroundColor Cyan }
function warn($msg) { Write-Host "  [!!]  $msg" -ForegroundColor Yellow }
function fail($msg) { Write-Host "  [ERR] $msg" -ForegroundColor Red; exit 1 }
function step($msg) {
  Write-Host ""
  Write-Host "══════════════════════════════════════════════" -ForegroundColor Cyan
  Write-Host "  $msg" -ForegroundColor Cyan
  Write-Host "══════════════════════════════════════════════" -ForegroundColor Cyan
}

# ─── Variables ────────────────────────────────────────────────────────────────
$TERRAFORM_VERSION   = "1.9.8"
$LOCALSTACK_CONTAINER = "localstack-main"
$LOCALSTACK_PORT     = "4566"
$LOCALSTACK_SERVICES = "ec2,s3,iam,sts,dynamodb"
$PLUGIN_CACHE_DIR    = "$env:USERPROFILE\.terraform.d\plugin-cache"
$TERRAFORMRC         = "$env:USERPROFILE\.terraformrc"

# ─── Bannière ─────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║       Terraform Beginners Guide — Setup Environment      ║" -ForegroundColor Cyan
Write-Host "  ║       Windows · Docker Desktop · LocalStack              ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ─── 1. Chocolatey ────────────────────────────────────────────────────────────
step "1. Gestionnaire de paquets (Chocolatey)"

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  info "Installation de Chocolatey..."
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  ok "Chocolatey installé"
} else {
  ok "Chocolatey déjà installé : $(choco version)"
}

# ─── 2. Terraform ─────────────────────────────────────────────────────────────
step "2. Terraform"

if (Get-Command terraform -ErrorAction SilentlyContinue) {
  $tfVer = (terraform version -json | ConvertFrom-Json).terraform_version
  ok "Terraform $tfVer déjà installé"
} else {
  info "Installation de Terraform $TERRAFORM_VERSION via Chocolatey..."
  choco install terraform --version $TERRAFORM_VERSION -y --no-progress
  ok "Terraform $TERRAFORM_VERSION installé"
}

terraform version | Select-Object -First 1

# ─── 3. Docker Desktop ────────────────────────────────────────────────────────
step "3. Docker Desktop"

if (Get-Command docker -ErrorAction SilentlyContinue) {
  try {
    $dockerVer = docker version --format '{{.Server.Version}}' 2>$null
    ok "Docker $dockerVer déjà installé"
  } catch {
    warn "Docker installé mais le démon ne tourne pas — démarrez Docker Desktop"
  }
} else {
  info "Installation de Docker Desktop via Chocolatey..."
  choco install docker-desktop -y --no-progress
  warn "Démarrez Docker Desktop manuellement et relancez ce script"
  exit 0
}

# ─── 4. LocalStack ────────────────────────────────────────────────────────────
step "4. LocalStack"

# Vérifier que Docker fonctionne
try {
  docker info > $null 2>&1
} catch {
  fail "Docker n'est pas accessible. Assurez-vous que Docker Desktop est démarré."
}

# Pull de l'image
info "Vérification de l'image LocalStack..."
docker pull localstack/localstack:latest --quiet 2>$null
ok "Image LocalStack disponible"

# Démarrer ou redémarrer le conteneur
$running = docker ps --filter "name=$LOCALSTACK_CONTAINER" --filter "status=running" -q
$exists  = docker ps -a --filter "name=$LOCALSTACK_CONTAINER" -q

if ($running) {
  ok "LocalStack déjà en cours d'exécution"
} elseif ($exists) {
  info "Redémarrage du conteneur LocalStack..."
  docker start $LOCALSTACK_CONTAINER > $null
  Start-Sleep -Seconds 10
  ok "LocalStack redémarré"
} else {
  info "Démarrage de LocalStack (services: $LOCALSTACK_SERVICES)..."
  docker run -d `
    --name $LOCALSTACK_CONTAINER `
    -p "${LOCALSTACK_PORT}:4566" `
    -e SERVICES=$LOCALSTACK_SERVICES `
    -e DEBUG=0 `
    -v /var/run/docker.sock:/var/run/docker.sock `
    localstack/localstack:latest > $null

  info "Attente du démarrage de LocalStack..."
  $attempts = 0
  do {
    Start-Sleep -Seconds 3
    $attempts++
    Write-Host -NoNewline "."
    try {
      $health = Invoke-RestMethod -Uri "http://localhost:${LOCALSTACK_PORT}/_localstack/health" -ErrorAction SilentlyContinue
      if ($health.running -eq $true) { break }
    } catch {}
    if ($attempts -gt 30) { fail "LocalStack n'a pas démarré après 90s" }
  } while ($true)
  Write-Host ""
  ok "LocalStack démarré et opérationnel"
}

ok "LocalStack endpoint : http://localhost:${LOCALSTACK_PORT}"

# ─── 5. Cache de plugins Terraform ────────────────────────────────────────────
step "5. Cache de plugins Terraform"

if (-not (Test-Path $PLUGIN_CACHE_DIR)) {
  New-Item -ItemType Directory -Path $PLUGIN_CACHE_DIR -Force > $null
}

Set-Content -Path $TERRAFORMRC -Value "plugin_cache_dir = `"$($PLUGIN_CACHE_DIR -replace '\\','/')`""
ok "Cache configuré : $PLUGIN_CACHE_DIR"
ok "Fichier .terraformrc créé : $TERRAFORMRC"

# ─── 6. Pré-téléchargement des providers ──────────────────────────────────────
step "6. Pré-téléchargement des providers Terraform"

$TMPDIR_TF = Join-Path $env:TEMP "tf-provider-cache-$(Get-Random)"
New-Item -ItemType Directory -Path $TMPDIR_TF -Force > $null

@'
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
'@ | Set-Content "$TMPDIR_TF\providers.tf"

info "Téléchargement des providers (une seule fois — mis en cache)..."
Push-Location $TMPDIR_TF
try {
  terraform init -input=false -no-color 2>&1 | Where-Object { $_ -match "(Installed|Using cached|Error)" } | ForEach-Object { Write-Host "    $_" }
} finally {
  Pop-Location
  Remove-Item -Recurse -Force $TMPDIR_TF -ErrorAction SilentlyContinue
}
ok "Tous les providers sont en cache"

# ─── 7. Dossiers output ───────────────────────────────────────────────────────
step "7. Création des dossiers output"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputModules = @(
  "04-Terraform-Top-Level-Blocks",
  "05-Terraform-Commands",
  "07-Terraform-Resources",
  "08-Terraform-Resource-Meta-Arguments\08-01-count",
  "08-Terraform-Resource-Meta-Arguments\08-02-for_each",
  "08-Terraform-Resource-Meta-Arguments\08-02-for_each\01-for_each-map",
  "08-Terraform-Resource-Meta-Arguments\08-02-for_each\02-for_each-set",
  "08-Terraform-Resource-Meta-Arguments\08-03-depends_on",
  "08-Terraform-Resource-Meta-Arguments\08-04-provider",
  "08-Terraform-Resource-Meta-Arguments\08-05-lifecycle",
  "08-Terraform-Resource-Meta-Arguments\08-05-lifecycle\01-create_before_destroy",
  "08-Terraform-Resource-Meta-Arguments\08-05-lifecycle\02-prevent_destroy",
  "08-Terraform-Resource-Meta-Arguments\08-05-lifecycle\03-ignore_changes",
  "09-Terraform-Variables",
  "09-Terraform-Variables\09-01-Terraform-Variables-tfvars",
  "09-Terraform-Variables\09-02-Terraform-Variables-tfvars-var-file",
  "09-Terraform-Variables\09-03-Terraform-Variables-list",
  "09-Terraform-Variables\09-04-Terraform-Variables-map",
  "09-Terraform-Variables\09-05-Custom-Validation-Rules",
  "09-Terraform-Variables\09-06-Sensitive-Variables",
  "10-Terraform-Outputs",
  "11-Terraform-Data-Sources",
  "13-Terraform-Show",
  "14-Terraform-Refresh",
  "15-Terraform-State-Commands",
  "19-Terraform-Debug",
  "20-Terraform-provisioners"
)

$created = 0
foreach ($mod in $outputModules) {
  $outdir = Join-Path $scriptDir "$mod\output"
  if (-not (Test-Path $outdir)) {
    New-Item -ItemType Directory -Path $outdir -Force > $null
    $created++
  }
}

# Sous-dossiers pour module 08-04
New-Item -ItemType Directory -Path "$scriptDir\08-Terraform-Resource-Meta-Arguments\08-04-provider\output\europe" -Force > $null
New-Item -ItemType Directory -Path "$scriptDir\08-Terraform-Resource-Meta-Arguments\08-04-provider\output\asia" -Force > $null

ok "$created dossier(s) output créé(s)"

# ─── 8. Résumé final ──────────────────────────────────────────────────────────
step "8. Résumé de l'environnement"

Write-Host ""
Write-Host "  Outils installés :" -ForegroundColor White
Write-Host ("    {0,-20} {1}" -f "Terraform",  (terraform version | Select-Object -First 1))
Write-Host ("    {0,-20} {1}" -f "Docker",     (docker version --format '{{.Server.Version}}' 2>$null))
Write-Host ("    {0,-20} {1}" -f "LocalStack", "http://localhost:4566")

Write-Host ""
Write-Host "  Providers Terraform en cache :" -ForegroundColor White
$cacheBase = "$PLUGIN_CACHE_DIR\registry.terraform.io\hashicorp"
if (Test-Path $cacheBase) {
  Get-ChildItem $cacheBase | ForEach-Object {
    $ver = (Get-ChildItem $_.FullName | Sort-Object Name | Select-Object -Last 1).Name
    Write-Host ("    {0,-25} {1}" -f "hashicorp/$($_.Name)", $ver)
  }
}

Write-Host ""
Write-Host "  Modules prêts a tester :" -ForegroundColor White
Write-Host "    Providers legers : 04 05 07 08 09 10 11 13 14 15 19 20"
Write-Host "    AWS via LocalStack : 06 12 16 17 18"
Write-Host ""
Write-Host "  OK  Environnement pret ! Lancez : terraform init && terraform apply" -ForegroundColor Green
Write-Host ""
Write-Host "  Commandes utiles :" -ForegroundColor White
Write-Host "    LocalStack : docker start/stop localstack-main"
Write-Host "    Sante      : Invoke-RestMethod http://localhost:4566/_localstack/health"
Write-Host "    Debug TF   : `$env:TF_LOG='DEBUG'; terraform plan"
Write-Host ""
