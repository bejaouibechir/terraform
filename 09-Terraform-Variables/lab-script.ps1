# ============================================================
# Lab 09 - Terraform Variables
# Exécuter depuis : 09-Terraform-Variables\
# ============================================================

# ── 09 : Variables (défaut) — répertoire courant ─────────────
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve

# ── 09-01 : Variables via fichier .tfvars ────────────────────
Set-Location 09-01-Terraform-Variables-tfvars
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
Set-Location ..

# ── 09-02 : Variables via fichier var-file ───────────────────
Set-Location 09-02-Terraform-Variables-tfvars-var-file
terraform init -upgrade
terraform fmt
terraform validate
# Le fichier dev.tfvars est passé explicitement avec -var-file
terraform plan -var-file=dev.tfvars
terraform apply -auto-approve -var-file=dev.tfvars
terraform destroy -auto-approve -var-file=dev.tfvars
Set-Location ..

# ── 09-03 : Variables de type list ──────────────────────────
Set-Location 09-03-Terraform-Variables-list
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
Set-Location ..

# ── 09-04 : Variables de type map ───────────────────────────
Set-Location 09-04-Terraform-Variables-map
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
Set-Location ..

# ── 09-05 : Custom Validation Rules ─────────────────────────
Set-Location 09-05-Custom-Validation-Rules
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
Set-Location ..

# ── 09-06 : Sensitive Variables ─────────────────────────────
Set-Location 09-06-Sensitive-Variables
terraform init -upgrade
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
Set-Location ..
