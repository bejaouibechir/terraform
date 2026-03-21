#!/bin/bash
# ######################################################
# Étude de Cas 3 : Provider Docker (kreuzwerker/docker)
# ######################################################
# PRÉREQUIS :
#   - Docker Desktop installé et démarré
# ######################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================================"
echo "  Étude de Cas 3 : Provider Docker"
echo "======================================================"

echo ""
echo "--- Vérification que Docker est démarré ---"
if docker info > /dev/null 2>&1; then
  echo "Docker est prêt !"
else
  echo "ERREUR : Docker n'est pas démarré. Lancez Docker Desktop."
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
echo "--- Vérification des conteneurs Docker ---"
docker ps --filter "label=managed-by=terraform" --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "--- Test de Nginx ---"
sleep 2
curl -s -o /dev/null -w "Nginx HTTP Status : %{http_code}\n" http://localhost:8080 || echo "Nginx non accessible"

echo ""
echo "--- Vérification du réseau Docker ---"
docker network inspect terraform-network --format "Réseau : {{.Name}} (Driver: {{.Driver}})"

echo ""
echo "--- terraform destroy (cleanup) ---"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
