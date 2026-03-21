#!/bin/bash
# ######################################################
# Lab : 05 - Terraform Commands
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
echo "# Step 6: terraform output"
echo "##################################################"
terraform output

echo ""
echo "##################################################"
echo "# Step 7: terraform show"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 8: terraform refresh"
echo "##################################################"
terraform refresh

echo ""
echo "##################################################"
echo "# Step 9: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
