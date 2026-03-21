# ######################################################
# Lab : 14 - Terraform Refresh
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
Write-Host "# Step 4: terraform plan" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform plan

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 5: terraform apply" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform apply -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 6: terraform show (état avant refresh)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform show

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: terraform refresh" -ForegroundColor Cyan
Write-Host "# NOTE : Ajoutez manuellement un tag sur le VPC depuis" -ForegroundColor Yellow
Write-Host "#        la Console AWS avant cette étape pour observer" -ForegroundColor Yellow
Write-Host "#        le comportement du refresh" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform refresh

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 8: terraform show (état après refresh)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform show

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 9: terraform plan" -ForegroundColor Cyan
Write-Host "# Vérifiez si des différences sont détectées" -ForegroundColor Yellow
Write-Host "##################################################" -ForegroundColor Cyan
terraform plan

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 10: terraform destroy (cleanup)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
