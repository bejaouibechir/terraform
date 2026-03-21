#!/bin/bash
# ######################################################
# Lab : 20 - Terraform Provisioners
# ######################################################
#
# PRÉREQUIS :
#   1. Une key pair AWS nommée "terraform-demo" doit exister
#      dans votre compte AWS (région us-east-1)
#   2. La clé privée doit être disponible à ~/.ssh/id_rsa
#      chmod 400 ~/.ssh/id_rsa
#
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
echo "# Step 3: terraform plan"
echo "##################################################"
terraform plan

echo ""
echo "##################################################"
echo "# Step 4: terraform apply"
echo "# Observez l'exécution des provisioners :"
echo "#   - local-exec  : écriture locale dans ec2-info.txt"
echo "#   - file        : copie de scripts/setup.sh sur l'instance"
echo "#   - remote-exec : installation Apache via SSH"
echo "##################################################"
terraform apply -auto-approve

echo ""
echo "##################################################"
echo "# Step 5: Vérifier le fichier ec2-info.txt (local-exec)"
echo "##################################################"
cat ec2-info.txt

echo ""
echo "##################################################"
echo "# Step 6: terraform output"
echo "# Récupérez l'URL du site web déployé"
echo "##################################################"
terraform output

echo ""
echo "##################################################"
echo "# Step 7: terraform show"
echo "##################################################"
terraform show

echo ""
echo "##################################################"
echo "# Step 8: terraform destroy (cleanup)"
echo "# Le provisioner when=destroy s'exécute avant la destruction"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "##################################################"
echo "# Step 9: Vérifier ec2-info.txt (local-exec when=destroy)"
echo "##################################################"
cat ec2-info.txt

echo ""
echo "Lab terminé avec succès !"
