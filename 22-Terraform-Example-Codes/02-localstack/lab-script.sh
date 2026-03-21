#!/bin/bash
# ######################################################
# Étude de Cas 2 : LocalStack — Simulateur AWS Local
# ######################################################
# PRÉREQUIS :
#   - Docker Desktop démarré
#   - LocalStack installé : pip install localstack
#   - awslocal CLI (optionnel) : pip install awscli-local
# ######################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================================"
echo "  Étude de Cas 2 : LocalStack — Simulateur AWS"
echo "======================================================"

echo ""
echo "--- Vérification que LocalStack est démarré ---"
if curl -s http://localhost:4566/_localstack/health > /dev/null 2>&1; then
  echo "LocalStack est prêt !"
else
  echo "ATTENTION : LocalStack ne semble pas démarré."
  echo "Lancez : localstack start -d"
  echo "Puis relancez ce script."
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
echo "--- Vérification avec awslocal (si disponible) ---"
if command -v awslocal &> /dev/null; then
  echo "VPCs :"
  awslocal ec2 describe-vpcs --output table
  echo ""
  echo "Buckets S3 :"
  awslocal s3 ls
else
  echo "awslocal non installé — vérification via curl :"
  curl -s "http://localhost:4566/tf-localstack-demo-bucket" | head -20
fi

echo ""
echo "--- terraform destroy (cleanup) ---"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
