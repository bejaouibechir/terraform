# ######################################################
# Lab : 20 - Terraform Provisioners
# ######################################################
#
# PRÉREQUIS :
#   1. Une key pair AWS nommée "terraform-demo" doit exister
#      dans votre compte AWS (région us-east-1)
#   2. La clé privée doit être disponible à ~/.ssh/id_rsa
#
# ######################################################

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
Write-Host "# Step 3: terraform plan" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform plan

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 4: terraform apply" -ForegroundColor Cyan
Write-Host "# Observez l'exécution des provisioners :" -ForegroundColor Yellow
Write-Host "#   - local-exec  : écriture locale dans ec2-info.txt" -ForegroundColor Yellow
Write-Host "#   - file        : copie de scripts/setup.sh sur l'instance" -ForegroundColor Yellow
Write-Host "#   - remote-exec : installation Apache via SSH" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 5: Vérifier le fichier ec2-info.txt (local-exec)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
Get-Content ec2-info.txt

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 6: terraform output" -ForegroundColor Cyan
Write-Host "# Récupérez l'URL du site web déployé" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform output

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: terraform show" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform show

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 8: terraform destroy (cleanup)" -ForegroundColor Cyan
Write-Host "# Le provisioner when=destroy s'exécute avant la destruction" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 9: Vérifier ec2-info.txt (local-exec when=destroy)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
Get-Content ec2-info.txt

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
