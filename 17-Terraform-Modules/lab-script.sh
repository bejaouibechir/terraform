#!/usr/bin/env bash
# ============================================================
# Lab 17 - Terraform Modules
# ============================================================

# Initialise et télécharge les modules déclarés
terraform init

# Formate aussi les fichiers dans le répertoire modules/
terraform fmt -recursive

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Dans le plan, observez les ressources préfixées module.vpc_dev.* et module.vpc_prod.*
terraform plan

# Crée les ressources pour les deux modules
terraform apply -auto-approve

# Affiche les outputs des deux modules (dev et prod)
terraform output

# Les ressources sont préfixées par module.<nom>.* dans le state
terraform state list

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve
