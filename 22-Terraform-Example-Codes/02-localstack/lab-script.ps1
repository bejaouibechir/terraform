# ######################################################
# Étude de Cas 2 : LocalStack — Simulateur AWS Local
# ######################################################
# PRÉREQUIS :
#   - Docker Desktop démarré
#   - LocalStack installé : pip install localstack
#   - awslocal CLI (optionnel) : pip install awscli-local
# ######################################################

Set-Location $PSScriptRoot

Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Étude de Cas 2 : LocalStack — Simulateur AWS" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta

Write-Host ""
Write-Host "--- Vérification que LocalStack est démarré ---" -ForegroundColor Cyan
try {
  $response = Invoke-WebRequest -Uri "http://localhost:4566/_localstack/health" -UseBasicParsing -ErrorAction Stop
  Write-Host "LocalStack est prêt !" -ForegroundColor Green
} catch {
  Write-Host "ATTENTION : LocalStack ne semble pas démarré." -ForegroundColor Red
  Write-Host "Lancez : localstack start -d" -ForegroundColor Yellow
  Write-Host "Puis relancez ce script." -ForegroundColor Yellow
  exit 1
}

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
Write-Host "--- terraform output ---" -ForegroundColor Cyan
terraform output

Write-Host ""
Write-Host "--- Vérification des ressources créées ---" -ForegroundColor Yellow
if (Get-Command awslocal -ErrorAction SilentlyContinue) {
  Write-Host "VPCs :" -ForegroundColor Yellow
  awslocal ec2 describe-vpcs --output table
  Write-Host ""
  Write-Host "Buckets S3 :" -ForegroundColor Yellow
  awslocal s3 ls
} else {
  Write-Host "awslocal non disponible — installez avec : pip install awscli-local" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "--- terraform destroy (cleanup) ---" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
