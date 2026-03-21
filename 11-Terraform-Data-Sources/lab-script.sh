#!/bin/bash
# ######################################################
# Lab : 11 - Terraform Data Sources
# ######################################################

set -e

echo "##################################################"
echo "# Step 1: terraform init"
echo "##################################################"
terraform init

echo ""
echo "##################################################"
echo "# Step 2: terraform fmt"
echo "##################################################"
terraform fmt

echo ""
echo "##################################################"
echo "# Step 3: terraform validate"
echo "##################################################"
terraform validate

echo ""
echo "##################################################"
echo "# Step 4: terraform plan"
echo "# Observez l'ID AMI récupéré dynamiquement via la data source"
echo "##################################################"
terraform plan

echo ""
echo "##################################################"
echo "# Step 5: terraform apply"
echo "##################################################"
terraform apply -auto-approve

echo ""
echo "##################################################"
echo "# Step 6: terraform show"
echo "# Vérifiez l'AMI utilisée par l'instance EC2"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 7: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
