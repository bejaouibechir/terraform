#!/usr/bin/env bash
# ============================================================
# Lab 16 - Terraform Workspaces
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Affiche le workspace actif (default au départ)
terraform workspace show

# Liste tous les workspaces existants
terraform workspace list

# ── Workspace DEV ────────────────────────────────────────────
# Crée et bascule vers le workspace dev
terraform workspace new dev
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

# ── Workspace STAGING ────────────────────────────────────────
# Crée et bascule vers le workspace staging
terraform workspace new staging
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

# ── Workspace PROD ───────────────────────────────────────────
# Crée et bascule vers le workspace prod
terraform workspace new prod
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

# Liste tous les workspaces (dev, staging, prod, default)
terraform workspace list

# Bascule vers dev et affiche ses outputs
terraform workspace select dev
terraform workspace show
terraform output

# ── Nettoyage : destroy dans chaque workspace ────────────────
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select staging
terraform destroy -auto-approve

terraform workspace select prod
terraform destroy -auto-approve

# Revient à default et supprime les workspaces créés
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod

# Vérifie qu'il ne reste que le workspace default
terraform workspace list
