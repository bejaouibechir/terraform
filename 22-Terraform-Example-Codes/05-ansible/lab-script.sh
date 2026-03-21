#!/bin/bash
# ######################################################
# Étude de Cas 5 : Intégration Terraform + Ansible
# ######################################################
# PRÉREQUIS :
#   - Credentials AWS configurés (aws configure)
#   - Key pair SSH créée dans AWS : terraform-ansible-key
#   - Clé privée disponible : ~/.ssh/terraform-ansible-key.pem
#   - Ansible installé : pip install ansible
#
# Créer la key pair :
#   aws ec2 create-key-pair --key-name terraform-ansible-key \
#     --query 'KeyMaterial' --output text > ~/.ssh/terraform-ansible-key.pem
#   chmod 400 ~/.ssh/terraform-ansible-key.pem
# ######################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================================"
echo "  Étude de Cas 5 : Terraform + Ansible"
echo "======================================================"

echo ""
echo "--- Vérification des prérequis ---"
if ! command -v ansible &> /dev/null; then
  echo "ERREUR : Ansible n'est pas installé."
  echo "Installez-le : pip install ansible"
  exit 1
fi
echo "Ansible version : $(ansible --version | head -1)"

if ! command -v aws &> /dev/null; then
  echo "AVERTISSEMENT : AWS CLI non installé."
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
echo "ATTENTION : Terraform va créer une instance EC2 (frais AWS)"
terraform apply -auto-approve

echo ""
echo "--- terraform output ---"
terraform output

echo ""
echo "--- Vérification du serveur web ---"
EC2_IP=$(terraform output -raw ec2_public_ip 2>/dev/null || echo "")
if [ -n "$EC2_IP" ]; then
  echo "Test HTTP sur http://${EC2_IP} :"
  curl -s -o /dev/null -w "HTTP Status : %{http_code}\n" "http://${EC2_IP}" || echo "Non accessible"
fi

echo ""
echo "--- Inventaire Ansible généré ---"
cat inventory.ini

echo ""
echo "--- terraform destroy (cleanup) ---"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
