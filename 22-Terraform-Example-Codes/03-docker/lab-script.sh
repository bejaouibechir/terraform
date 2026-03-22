#!/usr/bin/env bash
# ============================================================
# Étude de Cas 3 - Provider Docker (kreuzwerker/docker)
# PRÉREQUIS : Docker installé et démarré
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
docker ps --filter "label=managed-by=terraform" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

# Teste l'accès à Nginx (HTTP 200 attendu)
curl -s -o /dev/null -w "Nginx HTTP Status : %{http_code}\n" http://localhost:8080

# Vérifie le réseau Docker créé par Terraform
docker network inspect terraform-network --format "Réseau : {{.Name}} (Driver: {{.Driver}})"

# Détruit tous les conteneurs et le réseau (nettoyage)
terraform destroy -auto-approve
