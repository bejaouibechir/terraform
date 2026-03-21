#!/bin/bash
# ######################################################
# Lab : 13 - Terraform Show
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
echo "# Step 4: terraform plan -out=monplan.tfplan"
echo "# Sauvegarde le plan dans un fichier"
echo "##################################################"
terraform plan -out=monplan.tfplan

echo ""
echo "##################################################"
echo "# Step 5: terraform show monplan.tfplan"
echo "# Inspecte le fichier de plan avant apply"
echo "##################################################"
terraform show monplan.tfplan

echo ""
echo "##################################################"
echo "# Step 6: terraform apply"
echo "##################################################"
terraform apply -auto-approve

echo ""
echo "##################################################"
echo "# Step 7: terraform show"
echo "# Inspecte le state après apply"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 8: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

# Nettoyage du fichier de plan
rm -f monplan.tfplan

echo ""
echo "Lab terminé avec succès !"
