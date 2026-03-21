# ######################################################
# Étude de Cas 1 : Provider local (hashicorp/local)
# ######################################################
# PRÉREQUIS : Terraform installé uniquement (aucun compte cloud requis)
# ######################################################

Set-Location $PSScriptRoot

Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Étude de Cas 1 : Provider hashicorp/local" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta

Write-Host ""
Write-Host "--- terraform init ---" -ForegroundColor Cyan
terraform init

Write-Host ""
Write-Host "--- terraform fmt && validate ---" -ForegroundColor Cyan
terraform fmt
terraform validate

Write-Host ""
Write-Host "--- terraform plan ---" -ForegroundColor Cyan
terraform plan

Write-Host ""
Write-Host "--- terraform apply ---" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host ""
Write-Host "--- Vérification des fichiers générés ---" -ForegroundColor Yellow
Write-Host "Contenu de output/hello.txt :" -ForegroundColor Yellow
Get-Content "output/hello.txt"

Write-Host ""
Write-Host "Contenu de output/config.json :" -ForegroundColor Yellow
Get-Content "output/config.json"

Write-Host ""
Write-Host "Contenu de output/inventory.ini :" -ForegroundColor Yellow
Get-Content "output/inventory.ini"

Write-Host ""
Write-Host "--- terraform output ---" -ForegroundColor Cyan
terraform output

Write-Host ""
Write-Host "--- terraform destroy (cleanup) ---" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
