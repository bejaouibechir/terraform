#!/bin/bash
# ######################################################
# Lab : 14 - Terraform Refresh
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
echo "# Step 6: terraform show (état avant refresh)"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 7: terraform refresh"
echo "# Synchronise le state avec l'infrastructure réelle"
echo "# NOTE : Ajoutez manuellement un tag sur le VPC depuis"
echo "#        la Console AWS avant cette étape pour observer"
echo "#        le comportement du refresh"
echo "##################################################"
terraform refresh

echo ""
echo "##################################################"
echo "# Step 8: terraform show (état après refresh)"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 9: terraform plan"
echo "# Vérifiez si des différences sont détectées"
echo "##################################################"
terraform plan

echo ""
echo "##################################################"
echo "# Step 10: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
