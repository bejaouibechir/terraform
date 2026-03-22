#!/usr/bin/env bash
# ============================================================
# Lab 10 - Terraform Outputs
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les ressources
terraform apply -auto-approve

# Affiche tous les outputs définis dans outputs.tf
terraform output

# Affiche un output spécifique par son nom
terraform output myec2_public_ip

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve
