#!/usr/bin/env bash
# ============================================================
# Lab 04 - Terraform Top Level Blocks
# ============================================================

# Initialise le répertoire Terraform (télécharge les providers)
terraform init

# Formate les fichiers .tf selon le style HashiCorp
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les ressources déclarées dans les fichiers .tf
terraform apply -auto-approve

# Détruit toutes les ressources créées (nettoyage)
terraform destroy -auto-approve
