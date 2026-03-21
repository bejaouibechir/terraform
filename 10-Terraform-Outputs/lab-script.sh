#!/bin/bash
# ######################################################
# Lab : 10 - Terraform Outputs
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
echo "##################################################"
terraform plan

echo ""
echo "##################################################"
echo "# Step 5: terraform apply"
echo "##################################################"
terraform apply -auto-approve

echo ""
echo "##################################################"
echo "# Step 6: terraform output - afficher tous les outputs"
echo "##################################################"
terraform output

echo ""
echo "##################################################"
echo "# Step 7: terraform output - afficher un output spécifique"
echo "##################################################"
terraform output myec2_public_ip

echo ""
echo "##################################################"
echo "# Step 8: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
