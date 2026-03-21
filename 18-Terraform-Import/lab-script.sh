#!/bin/bash
# ######################################################
# Lab : 18 - Terraform Import
# ######################################################
#
# PRÉREQUIS : Remplacez VPC_ID par l'ID réel du VPC
#             existant dans votre compte AWS
#             ex : vpc-0ab12cd34ef567890
#
# ######################################################

VPC_ID="vpc-XXXXXXXXXXXXXXXXX"   # <-- Remplacez par votre VPC ID

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
echo "# Step 3: Déclarer le bloc vide dans 02_vpc.tf"
echo "# puis exécuter terraform import"
echo "##################################################"
echo "NOTE : Assurez-vous que 02_vpc.tf contient un bloc vide :"
echo "  resource \"aws_vpc\" \"imported\" {}"
echo ""
echo "Exécution de terraform import..."
terraform import aws_vpc.imported "$VPC_ID"

echo ""
echo "##################################################"
echo "# Step 4: terraform show"
echo "# Inspectez les attributs du VPC importé"
echo "# et mettez à jour 02_vpc.tf en conséquence"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 5: terraform plan"
echo "# Après mise à jour de 02_vpc.tf,"
echo "# vérifiez qu'il n'y a aucun changement détecté"
echo "##################################################"
terraform plan

echo ""
echo "##################################################"
echo "# Step 6: terraform apply"
echo "# Confirme la gestion Terraform du VPC importé"
echo "##################################################"
terraform apply -auto-approve

echo ""
echo "##################################################"
echo "# Step 7: terraform output"
echo "##################################################"
terraform output

echo ""
echo "Lab terminé avec succès !"
echo "NOTE : Le VPC importé est maintenant géré par Terraform."
echo "       Utilisez 'terraform destroy' si vous souhaitez le supprimer."
