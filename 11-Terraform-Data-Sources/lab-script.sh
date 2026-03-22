#!/usr/bin/env bash
# ============================================================
# Lab 11 - Terraform Data Sources
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Dans le plan, observez l'ID AMI récupéré dynamiquement via la data source
terraform plan

# Crée les ressources (l'AMI est résolue automatiquement)
terraform apply -auto-approve

# Vérifiez l'AMI utilisée par l'instance EC2 dans le state
terraform show

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve
