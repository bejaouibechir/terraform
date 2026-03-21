# ######################################################
# Lab : 15 - Terraform State Commands
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
Write-Host "# Step 3: terraform apply" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 4: terraform state list" -ForegroundColor Cyan
Write-Host "# Liste toutes les resources dans le state" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform state list

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 5: terraform state show <resource>" -ForegroundColor Cyan
Write-Host "# Affiche les détails d'une resource spécifique" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform state show aws_vpc.myvpc

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 6: terraform state pull" -ForegroundColor Cyan
Write-Host "# Récupère et affiche le state courant" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform state pull

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: terraform show" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform show

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 8: terraform destroy (cleanup)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
