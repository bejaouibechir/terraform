# ######################################################
# Lab : 17 - Terraform Modules
# ######################################################

Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 1: terraform init" -ForegroundColor Cyan
Write-Host "# Télécharge les modules et providers" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform init

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 2: terraform fmt -recursive" -ForegroundColor Cyan
Write-Host "# Formate aussi les fichiers dans modules/" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform fmt -recursive

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 3: terraform validate" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform validate

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 4: terraform plan" -ForegroundColor Cyan
Write-Host "# Observez les resources pour chaque module" -ForegroundColor Yellow
Write-Host "# (module.vpc_dev.* et module.vpc_prod.*)" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform plan

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 5: terraform apply" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 6: terraform output" -ForegroundColor Cyan
Write-Host "# Affiche les outputs des deux modules" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform output

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: terraform state list" -ForegroundColor Cyan
Write-Host "# Observez les resources préfixées par module.*" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform state list

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 8: terraform destroy (cleanup)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
