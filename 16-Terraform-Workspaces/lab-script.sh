#!/bin/bash
# ######################################################
# Lab : 16 - Terraform Workspaces
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
echo "# Step 3: Vérifier le workspace actif (default)"
echo "##################################################"
terraform workspace show
terraform workspace list

echo ""
echo "##################################################"
echo "# Step 4: Créer et déployer le workspace DEV"
echo "##################################################"
terraform workspace new dev
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

echo ""
echo "##################################################"
echo "# Step 5: Créer et déployer le workspace STAGING"
echo "##################################################"
terraform workspace new staging
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

echo ""
echo "##################################################"
echo "# Step 6: Créer et déployer le workspace PROD"
echo "##################################################"
terraform workspace new prod
terraform workspace show
terraform plan
terraform apply -auto-approve
terraform output

echo ""
echo "##################################################"
echo "# Step 7: Lister tous les workspaces"
echo "##################################################"
terraform workspace list

echo ""
echo "##################################################"
echo "# Step 8: Basculer entre workspaces"
echo "##################################################"
terraform workspace select dev
terraform workspace show
terraform output

echo ""
echo "##################################################"
echo "# Step 9: terraform destroy dans chaque workspace (cleanup)"
echo "##################################################"
terraform workspace select dev
terraform destroy -auto-approve

terraform workspace select staging
terraform destroy -auto-approve

terraform workspace select prod
terraform destroy -auto-approve

echo ""
echo "##################################################"
echo "# Step 10: Supprimer les workspaces et revenir à default"
echo "##################################################"
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
terraform workspace list

echo ""
echo "Lab terminé avec succès !"
