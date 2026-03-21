# ######################################################
# Lab : 06 - Terraform VPC Demo
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
Write-Host "# Step 6: terraform output" -ForegroundColor Cyan
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
Write-Host "##################################################" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
