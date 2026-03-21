#!/bin/bash
# ######################################################
# Lab : 17 - Terraform Modules
# ######################################################

set -e

echo "##################################################"
echo "# Step 1: terraform init"
echo "# Télécharge les modules et providers"
echo "##################################################"
terraform init

echo ""
echo "##################################################"
echo "# Step 2: terraform fmt -recursive"
echo "# Formate aussi les fichiers dans modules/"
echo "##################################################"
terraform fmt -recursive

echo ""
echo "##################################################"
echo "# Step 3: terraform validate"
echo "##################################################"
terraform validate

echo ""
echo "##################################################"
echo "# Step 4: terraform plan"
echo "# Observez les resources créées pour chaque module"
echo "# (module.vpc_dev.* et module.vpc_prod.*)"
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
echo "# Affiche les outputs des deux modules"
echo "##################################################"
terraform output

echo ""
echo "##################################################"
echo "# Step 7: terraform state list"
echo "# Observez les resources préfixées par module.*"
echo "##################################################"
terraform state list

echo ""
echo "##################################################"
echo "# Step 8: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "Lab terminé avec succès !"
