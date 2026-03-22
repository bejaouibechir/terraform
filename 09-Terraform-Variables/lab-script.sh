#!/usr/bin/env bash
# ============================================================
# Lab 09 - Terraform Variables
# Exécuter depuis : 09-Terraform-Variables/
# ============================================================

# ── 09 : Variables (défaut) — répertoire courant ─────────────
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

# ── 09-01 : Variables via fichier .tfvars ────────────────────
cd 09-01-Terraform-Variables-tfvars
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
cd ..

# ── 09-02 : Variables via fichier var-file ───────────────────
cd 09-02-Terraform-Variables-tfvars-var-file
terraform init -upgrade
terraform fmt
terraform validate
# Le fichier dev.tfvars est passé explicitement avec -var-file
terraform plan -var-file=dev.tfvars
terraform apply -auto-approve -var-file=dev.tfvars
terraform destroy -auto-approve -var-file=dev.tfvars
cd ..

# ── 09-03 : Variables de type list ──────────────────────────
cd 09-03-Terraform-Variables-list
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
cd ..

# ── 09-04 : Variables de type map ───────────────────────────
cd 09-04-Terraform-Variables-map
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
cd ..

# ── 09-05 : Custom Validation Rules ─────────────────────────
cd 09-05-Custom-Validation-Rules
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
cd ..

# ── 09-06 : Sensitive Variables ─────────────────────────────
cd 09-06-Sensitive-Variables
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
cd ..
