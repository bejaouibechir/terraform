# ######################################################
# Lab : 18 - Terraform Import
# ######################################################
#
# PRÉREQUIS : Remplacez VPC_ID par l'ID réel du VPC
#             existant dans votre compte AWS
#             ex : vpc-0ab12cd34ef567890
#
# ######################################################

$VPC_ID = "vpc-XXXXXXXXXXXXXXXXX"   # <-- Remplacez par votre VPC ID

Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 1: terraform init" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform init

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 2: terraform fmt && validate" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform fmt
terraform validate

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 3: terraform import" -ForegroundColor Cyan
Write-Host "# Assurez-vous que 02_vpc.tf contient un bloc vide :" -ForegroundColor Yellow
Write-Host '#   resource "aws_vpc" "imported" {}' -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform import aws_vpc.imported $VPC_ID

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 4: terraform show" -ForegroundColor Cyan
Write-Host "# Inspectez les attributs et mettez à jour 02_vpc.tf" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform show

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 5: terraform plan" -ForegroundColor Cyan
Write-Host "# Vérifiez qu'il n'y a aucun changement détecté" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform plan

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 6: terraform apply" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: terraform output" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform output

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
Write-Host "NOTE : Le VPC importé est maintenant géré par Terraform." -ForegroundColor Yellow
Write-Host "       Utilisez 'terraform destroy' si vous souhaitez le supprimer." -ForegroundColor Yellow
