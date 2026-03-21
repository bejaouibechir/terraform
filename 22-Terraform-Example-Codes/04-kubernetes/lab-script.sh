#!/bin/bash
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

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================================"
echo "  Étude de Cas 4 : Provider Kubernetes"
echo "======================================================"

echo ""
echo "--- Vérification du cluster Kubernetes ---"
if kubectl cluster-info > /dev/null 2>&1; then
  echo "Cluster Kubernetes accessible !"
  kubectl get nodes
else
  echo "ERREUR : Cluster Kubernetes non accessible."
  echo "Démarrez minikube : minikube start"
  echo "Ou kind           : kind create cluster --name terraform-demo"
  exit 1
fi

echo ""
echo "--- terraform init ---"
terraform init

echo ""
echo "--- terraform fmt && validate ---"
terraform fmt
terraform validate

echo ""
echo "--- terraform plan ---"
terraform plan

echo ""
echo "--- terraform apply ---"
terraform apply -auto-approve

echo ""
echo "--- terraform output ---"
terraform output

echo ""
echo "--- Vérification Kubernetes ---"
echo "Namespace :"
kubectl get namespace terraform-demo

echo ""
echo "Pods :"
kubectl get pods -n terraform-demo

echo ""
echo "Services :"
kubectl get service -n terraform-demo

echo ""
echo "ConfigMap :"
kubectl get configmap -n terraform-demo

echo ""
echo "--- Test d'accès (minikube) ---"
if command -v minikube &> /dev/null; then
  MINIKUBE_IP=$(minikube ip 2>/dev/null || echo "")
  if [ -n "$MINIKUBE_IP" ]; then
    echo "URL application : http://${MINIKUBE_IP}:30080"
    curl -s -o /dev/null -w "HTTP Status : %{http_code}\n" "http://${MINIKUBE_IP}:30080" || true
  fi
fi

echo ""
echo "--- terraform destroy (cleanup) ---"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
