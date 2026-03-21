# ######################################################
# Étude de Cas 3 : Provider Docker (kreuzwerker/docker)
# ######################################################
# PRÉREQUIS :
#   - Docker Desktop installé et démarré
# ######################################################

Set-Location $PSScriptRoot

Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Étude de Cas 3 : Provider Docker" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta

Write-Host ""
Write-Host "--- Vérification que Docker est démarré ---" -ForegroundColor Cyan
$dockerInfo = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Host "ERREUR : Docker n'est pas démarré. Lancez Docker Desktop." -ForegroundColor Red
  exit 1
}
Write-Host "Docker est prêt !" -ForegroundColor Green

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
Write-Host "--- Vérification des conteneurs Docker ---" -ForegroundColor Yellow
docker ps --filter "label=managed-by=terraform" --format "table {{.Names}}`t{{.Image}}`t{{.Status}}`t{{.Ports}}"

Write-Host ""
Write-Host "--- Test de Nginx ---" -ForegroundColor Yellow
Start-Sleep -Seconds 2
try {
  $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing
  Write-Host "Nginx HTTP Status : $($response.StatusCode)" -ForegroundColor Green
} catch {
  Write-Host "Nginx non accessible : $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "--- terraform destroy (cleanup) ---" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
