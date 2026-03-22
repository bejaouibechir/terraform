# ============================================================
# Étude de Cas 3 - Provider Docker (kreuzwerker/docker)
# PRÉREQUIS : Docker Desktop installé et démarré
# ============================================================

# Vérifie que Docker est démarré
docker info

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les conteneurs et le réseau Docker via Terraform
terraform apply -auto-approve

# Affiche les outputs (ports, noms des conteneurs)
terraform output

# Liste les conteneurs gérés par Terraform
docker ps --filter "label=managed-by=terraform" --format "table {{.Names}}`t{{.Image}}`t{{.Status}}`t{{.Ports}}"

# Teste l'accès à Nginx (HTTP 200 attendu)
Invoke-WebRequest -Uri http://localhost:8080 -UseBasicParsing

# Vérifie le réseau Docker créé par Terraform
docker network inspect terraform-network

# Détruit tous les conteneurs et le réseau (nettoyage)
terraform destroy -auto-approve
