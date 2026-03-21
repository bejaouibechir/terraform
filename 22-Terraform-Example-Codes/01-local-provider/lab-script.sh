#!/bin/bash
# ######################################################
# Étude de Cas 1 : Provider local (hashicorp/local)
# ######################################################
# PRÉREQUIS : Terraform installé uniquement (aucun compte cloud requis)
# ######################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================================"
echo "  Étude de Cas 1 : Provider hashicorp/local"
echo "======================================================"

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
echo "--- Vérification des fichiers générés ---"
echo "Contenu de output/hello.txt :"
cat output/hello.txt

echo ""
echo "Contenu de output/config.json :"
cat output/config.json

echo ""
echo "Contenu de output/inventory.ini :"
cat output/inventory.ini

echo ""
echo "--- terraform outputs ---"
terraform output

echo ""
echo "--- terraform destroy (cleanup) ---"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
