# ######################################################
# Étude de Cas 5 : Intégration Terraform + Ansible
# ######################################################
# PRÉREQUIS :
#   - Credentials AWS configurés (aws configure)
#   - Key pair SSH créée dans AWS : terraform-ansible-key
#   - Clé privée disponible : ~/.ssh/terraform-ansible-key.pem
#   - Ansible installé : pip install ansible
#   - IMPORTANT : Ansible est une commande Linux/Mac.
#     Sur Windows, utilisez WSL2 ou exécutez ce lab depuis WSL.
# ######################################################

Set-Location $PSScriptRoot

Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Étude de Cas 5 : Terraform + Ansible" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta

Write-Host ""
Write-Host "--- Vérification des prérequis ---" -ForegroundColor Cyan
if (-not (Get-Command ansible -ErrorAction SilentlyContinue)) {
  Write-Host "ATTENTION : Ansible n'est pas disponible dans ce shell." -ForegroundColor Yellow
  Write-Host "Sur Windows, utilisez WSL2 pour exécuter ce lab." -ForegroundColor Yellow
  Write-Host "Dans WSL2 : pip install ansible" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "Vous pouvez quand même continuer pour créer l'infrastructure Terraform." -ForegroundColor Cyan
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
Write-Host "ATTENTION : Terraform va créer une instance EC2 (frais AWS)" -ForegroundColor Yellow
terraform apply -auto-approve

Write-Host ""
Write-Host "--- terraform output ---" -ForegroundColor Cyan
terraform output

Write-Host ""
Write-Host "--- Inventaire Ansible généré ---" -ForegroundColor Yellow
if (Test-Path "inventory.ini") {
  Get-Content "inventory.ini"
}

Write-Host ""
Write-Host "--- Vérification du serveur web ---" -ForegroundColor Yellow
$ec2Ip = terraform output -raw ec2_public_ip 2>$null
if ($ec2Ip) {
  Write-Host "Test HTTP sur http://${ec2Ip} :" -ForegroundColor Yellow
  try {
    $response = Invoke-WebRequest -Uri "http://${ec2Ip}" -UseBasicParsing -TimeoutSec 10
    Write-Host "HTTP Status : $($response.StatusCode)" -ForegroundColor Green
  } catch {
    Write-Host "Non accessible (Ansible n'a peut-être pas pu s'exécuter depuis Windows)" -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host "--- terraform destroy (cleanup) ---" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
