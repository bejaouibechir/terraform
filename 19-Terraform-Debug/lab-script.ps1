# ######################################################
# Lab : 19 - Terraform Debug
# ######################################################

Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 1: Activer la journalisation TRACE" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
$env:TF_LOG = "TRACE"
$env:TF_LOG_PATH = "terraform-trace.log"
Write-Host "TF_LOG=$env:TF_LOG" -ForegroundColor Yellow
Write-Host "TF_LOG_PATH=$env:TF_LOG_PATH" -ForegroundColor Yellow

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 2: terraform init (logs TRACE générés)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform init

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
Write-Host "# Step 6: Inspecter le fichier de log" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "--- Nombre de lignes dans le log TRACE ---" -ForegroundColor Yellow
(Get-Content terraform-trace.log).Count
Write-Host ""
Write-Host "--- Aperçu des 20 premières lignes ---" -ForegroundColor Yellow
Get-Content terraform-trace.log | Select-Object -First 20
Write-Host ""
Write-Host "--- Recherche des appels API AWS ---" -ForegroundColor Yellow
Select-String -Path terraform-trace.log -Pattern "POST|GET|PUT" | Select-Object -First 10

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 7: Changer le niveau de log à INFO" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
$env:TF_LOG = "INFO"
Write-Host "TF_LOG=$env:TF_LOG" -ForegroundColor Yellow
terraform refresh

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 8: Désactiver la journalisation" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
Remove-Item Env:TF_LOG -ErrorAction SilentlyContinue
Remove-Item Env:TF_LOG_PATH -ErrorAction SilentlyContinue
Write-Host "Journalisation désactivée." -ForegroundColor Green

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 9: terraform destroy (cleanup)" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "##################################################" -ForegroundColor Cyan
Write-Host "# Step 10: Nettoyage des fichiers de log" -ForegroundColor Cyan
Write-Host "##################################################" -ForegroundColor Cyan
Remove-Item -Recurse -Force .terraform* -ErrorAction SilentlyContinue
Remove-Item -Force terraform.tfstate* -ErrorAction SilentlyContinue
Remove-Item -Force terraform-trace.log -ErrorAction SilentlyContinue
Write-Host "Fichiers de log supprimés." -ForegroundColor Green

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
