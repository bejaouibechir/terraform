# ######################################################
# Étude de Cas 4 : Provider Kubernetes
# ######################################################
# PRÉREQUIS :
#   - minikube OU kind installé et démarré
#   - kubectl configuré (fichier ~/.kube/config présent)
#
# Démarrer minikube : minikube start
# Démarrer kind     : kind create cluster --name terraform-demo
# ######################################################

Set-Location $PSScriptRoot

Write-Host "======================================================" -ForegroundColor Magenta
Write-Host "  Étude de Cas 4 : Provider Kubernetes" -ForegroundColor Magenta
Write-Host "======================================================" -ForegroundColor Magenta

Write-Host ""
Write-Host "--- Vérification du cluster Kubernetes ---" -ForegroundColor Cyan
$clusterInfo = kubectl cluster-info 2>&1
if ($LASTEXITCODE -ne 0) {
  Write-Host "ERREUR : Cluster Kubernetes non accessible." -ForegroundColor Red
  Write-Host "Démarrez minikube : minikube start" -ForegroundColor Yellow
  Write-Host "Ou kind           : kind create cluster --name terraform-demo" -ForegroundColor Yellow
  exit 1
}
Write-Host "Cluster Kubernetes accessible !" -ForegroundColor Green
kubectl get nodes

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
Write-Host "--- Vérification Kubernetes ---" -ForegroundColor Yellow
Write-Host "Namespace :" -ForegroundColor Yellow
kubectl get namespace terraform-demo

Write-Host ""
Write-Host "Pods :" -ForegroundColor Yellow
kubectl get pods -n terraform-demo

Write-Host ""
Write-Host "Services :" -ForegroundColor Yellow
kubectl get service -n terraform-demo

Write-Host ""
Write-Host "ConfigMap :" -ForegroundColor Yellow
kubectl get configmap -n terraform-demo

Write-Host ""
Write-Host "--- Test d'accès (minikube) ---" -ForegroundColor Yellow
if (Get-Command minikube -ErrorAction SilentlyContinue) {
  $minikubeIp = minikube ip 2>$null
  if ($minikubeIp) {
    Write-Host "URL application : http://${minikubeIp}:30080" -ForegroundColor Green
  }
}

Write-Host ""
Write-Host "--- terraform destroy (cleanup) ---" -ForegroundColor Cyan
terraform destroy -auto-approve

Write-Host ""
Write-Host "Lab terminé avec succès !" -ForegroundColor Green
