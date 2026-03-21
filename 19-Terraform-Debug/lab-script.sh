#!/bin/bash
# ######################################################
# Lab : 19 - Terraform Debug
# ######################################################

set -e

echo "##################################################"
echo "# Step 1: Activer la journalisation TRACE"
echo "##################################################"
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"
echo "TF_LOG=$TF_LOG"
echo "TF_LOG_PATH=$TF_LOG_PATH"

echo ""
echo "##################################################"
echo "# Step 2: terraform init (logs TRACE générés)"
echo "##################################################"
terraform init

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
echo "# Step 6: Inspecter le fichier de log"
echo "##################################################"
echo "--- Nombre de lignes dans le log TRACE ---"
wc -l terraform-trace.log
echo ""
echo "--- Aperçu des 20 premières lignes ---"
head -20 terraform-trace.log
echo ""
echo "--- Recherche des appels API AWS ---"
grep "POST\|GET\|PUT" terraform-trace.log | head -10

echo ""
echo "##################################################"
echo "# Step 7: Changer le niveau de log à INFO"
echo "##################################################"
export TF_LOG=INFO
echo "TF_LOG=$TF_LOG"
terraform refresh

echo ""
echo "##################################################"
echo "# Step 8: Désactiver la journalisation"
echo "##################################################"
unset TF_LOG
unset TF_LOG_PATH
echo "Journalisation désactivée."

echo ""
echo "##################################################"
echo "# Step 9: terraform destroy (cleanup)"
echo "##################################################"
terraform destroy -auto-approve

echo ""
echo "##################################################"
echo "# Step 10: Nettoyage des fichiers de log"
echo "##################################################"
rm -rf .terraform*
rm -f terraform.tfstate*
rm -f terraform-trace.log
echo "Fichiers de log supprimés."

echo ""
echo "Lab terminé avec succès !"
