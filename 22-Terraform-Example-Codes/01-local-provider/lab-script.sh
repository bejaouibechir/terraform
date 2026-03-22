#!/usr/bin/env bash
# ============================================================
# Étude de Cas 1 - Provider hashicorp/local
# PRÉREQUIS : Terraform installé (aucun compte cloud requis)
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les fichiers locaux via le provider local
terraform apply -auto-approve

# Vérifie les fichiers générés par le provider
cat output/hello.txt
cat output/config.json
cat output/inventory.ini

# Affiche les outputs Terraform
terraform output

# Détruit toutes les ressources (supprime les fichiers créés)
terraform destroy -auto-approve
