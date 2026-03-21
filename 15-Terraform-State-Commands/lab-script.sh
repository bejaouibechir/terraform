#!/bin/bash
# ######################################################
# Lab : 15 - Terraform State Commands
# ######################################################

set -e

echo "##################################################"
echo "# Step 1: terraform init"
echo "##################################################"
terraform init

echo ""
echo "##################################################"
echo "# Step 2: terraform fmt && validate"
echo "##################################################"
terraform fmt
terraform validate

echo ""
echo "##################################################"
echo "# Step 3: terraform apply"
echo "##################################################"
terraform apply -auto-approve

echo ""
echo "##################################################"
echo "# Step 4: terraform state list"
echo "# Liste toutes les resources dans le state"
echo "##################################################"
terraform state list

echo ""
echo "##################################################"
echo "# Step 5: terraform state show <resource>"
echo "# Affiche les détails d'une resource spécifique"
echo "##################################################"
terraform state show aws_vpc.myvpc

echo ""
echo "##################################################"
echo "# Step 6: terraform state pull"
echo "# Récupère et affiche le state courant"
echo "##################################################"
terraform state pull

echo ""
echo "##################################################"
echo "# Step 7: terraform show"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 8: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
