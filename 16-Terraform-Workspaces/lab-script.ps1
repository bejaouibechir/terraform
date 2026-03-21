# ######################################################
# Lab : 16 - Terraform Workspaces
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
Write-Host "# Step 3: Vérifier le workspace actif (default)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace show
terraform workspace list

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 4: Créer et déployer le workspace DEV" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace new dev
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 5: Créer et déployer le workspace STAGING" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace new staging
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 6: Créer et déployer le workspace PROD" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace new prod
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: Lister tous les workspaces" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace list

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 8: Basculer entre workspaces" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace select dev
terraform workspace show
terraform output

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 9: terraform destroy dans chaque workspace (cleanup)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select staging
terraform destroy -auto-approve

terraform workspace select prod
terraform destroy -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 10: Supprimer les workspaces et revenir à default" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
terraform workspace list

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
