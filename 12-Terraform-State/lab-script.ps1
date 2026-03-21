# ######################################################
# Lab : 12 - Terraform State
# ######################################################
#
# PRÉREQUIS (State Distant) :
#   - Bucket S3 : "tf-aws-backend" créé dans us-east-1
#   - Dossier S3 : "tf/dev/"
#   - Table DynamoDB : "tf-dev-state-lock" avec clé "LockID"
#
# ######################################################

Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Option A : State LOCAL" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta

Set-Location "$PSScriptRoot\tf-state-demo-files\local"

Write-Host "--- terraform init ---" -ForegroundColor Cyan
terraform init

Write-Host "--- terraform fmt && validate ---" -ForegroundColor Cyan
terraform fmt
terraform validate

Write-Host "--- terraform apply ---" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host "--- Vérifier le fichier state local ---" -ForegroundColor Yellow
Get-Item terraform.tfstate | Select-Object Name, Length, LastWriteTime
Write-Host "Le state est stocké localement dans terraform.tfstate" -ForegroundColor Yellow

Write-Host "--- terraform destroy ---" -ForegroundColor Cyan
terraform destroy -auto-approve

Set-Location $PSScriptRoot

Write-Host ""
Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Option B : State DISTANT (S3 + DynamoDB)" -ForegroundColor Magenta
Write-Host "  PRÉREQUIS : Bucket S3 et Table DynamoDB requis" -ForegroundColor Yellow
Write-Host "======================================================" -ForegroundColor Magenta

Write-Host "--- terraform init (backend S3) ---" -ForegroundColor Cyan
terraform init

Write-Host "--- terraform fmt && validate ---" -ForegroundColor Cyan
terraform fmt
terraform validate

Write-Host "--- terraform plan ---" -ForegroundColor Cyan
Write-Host "Observez l'acquisition du verrou de state (DynamoDB)" -ForegroundColor Yellow
terraform plan

Write-Host "--- terraform apply ---" -ForegroundColor Cyan
Write-Host "Observez Acquiring/Releasing state lock" -ForegroundColor Yellow
terraform apply -auto-approve

Write-Host "--- terraform state list ---" -ForegroundColor Cyan
terraform state list

Write-Host "--- terraform state show aws_vpc.myvpc ---" -ForegroundColor Cyan
terraform state show aws_vpc.myvpc

Write-Host "--- terraform state pull ---" -ForegroundColor Cyan
terraform state pull

Write-Host "--- terraform destroy ---" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
