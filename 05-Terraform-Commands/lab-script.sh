#!/usr/bin/env bash
# ============================================================
# Lab 05 - Terraform Commands
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

# Affiche tous les outputs définis dans outputs.tf
terraform output

# Inspecte l'état courant (state) de l'infrastructure
terraform show

# Synchronise le state avec l'infrastructure réelle
terraform refresh

# Détruit toutes les ressources créées (nettoyage)
terraform destroy -auto-approve
