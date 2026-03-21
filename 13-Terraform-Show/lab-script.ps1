# ######################################################
# Lab : 13 - Terraform Show
# ######################################################

Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 1: terraform init" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform init

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 2: terraform fmt" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform fmt

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 3: terraform validate" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform validate

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 4: terraform plan -out=monplan.tfplan" -ForegroundColor Cyan
Write-Host "# Sauvegarde le plan dans un fichier" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform plan -out=monplan.tfplan

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 5: terraform show monplan.tfplan" -ForegroundColor Cyan
Write-Host "# Inspecte le fichier de plan avant apply" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform show monplan.tfplan

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 6: terraform apply" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: terraform show" -ForegroundColor Cyan
Write-Host "# Inspecte le state après apply" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform show

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 8: terraform destroy (cleanup)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform destroy -auto-approve

# Nettoyage du fichier de plan
Remove-Item -Force monplan.tfplan -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
