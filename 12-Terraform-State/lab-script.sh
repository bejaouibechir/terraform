#!/bin/bash
# ######################################################
# Lab : 12 - Terraform State
# ######################################################
#
# PRÉREQUIS (State Distant) :
#   - Bucket S3 : "tf-aws-backend" créé dans us-east-1
#   - Dossier S3 : "tf/dev/"
#   - Table DynamoDB : "tf-dev-state-lock" avec clé "LockID"
#
# Deux options disponibles :
#   Option A : State LOCAL  (tf-state-demo-files/local/)
#   Option B : State DISTANT S3 (répertoire principal)
#
# ######################################################

set -e

echo "======================================================"
echo "  Option A : State LOCAL"
echo "======================================================"
cd "$(dirname "$0")/tf-state-demo-files/local"

echo "--- terraform init ---"
terraform init

echo "--- terraform fmt && validate ---"
terraform fmt
terraform validate

echo "--- terraform apply ---"
terraform apply -auto-approve

echo "--- Vérifier le fichier state local ---"
ls -lh terraform.tfstate
echo "Le state est stocké localement dans terraform.tfstate"

echo "--- terraform destroy ---"
terraform destroy -auto-approve

cd - > /dev/null

echo ""
echo "======================================================"
echo "  Option B : State DISTANT (S3 + DynamoDB)"
echo "  PRÉREQUIS : Bucket S3 et Table DynamoDB requis"
echo "======================================================"
cd "$(dirname "$0")"

echo "--- terraform init (backend S3) ---"
terraform init

echo "--- terraform fmt && validate ---"
terraform fmt
terraform validate

echo "--- terraform plan ---"
echo "Observez l'acquisition du verrou de state (DynamoDB)"
terraform plan

echo "--- terraform apply ---"
echo "Observez Acquiring/Releasing state lock"
terraform apply -auto-approve

echo "--- terraform state list ---"
terraform state list

echo "--- terraform state show aws_vpc.myvpc ---"
terraform state show aws_vpc.myvpc

echo "--- terraform state pull ---"
terraform state pull

echo "--- terraform destroy ---"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
