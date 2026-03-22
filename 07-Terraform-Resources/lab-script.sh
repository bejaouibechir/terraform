#!/usr/bin/env bash
# ============================================================
# Lab 07 - Terraform Resources
# ============================================================

# Initialise le répertoire Terraform (télécharge les providers)
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les ressources déclarées
terraform apply -auto-approve

# Inspecte l'état de l'infrastructure créée
terraform show

# Détruit toutes les ressources créées (nettoyage)
terraform destroy -auto-approve
