#!/bin/bash
# ######################################################
# Lab : 09 - Terraform Variables
# Ce script itère sur chaque sous-lab indépendamment
# ######################################################

run_lab() {
  local dir=$1
  local name=$2
  local extra_args=${3:-""}
  echo ""
  echo "======================================================"
  echo "  LAB : $name"
  echo "  Répertoire : $dir"
  echo "======================================================"
  cd "$dir"

  echo "--- terraform init ---"
  terraform init -upgrade

  echo "--- terraform fmt ---"
  terraform fmt

  echo "--- terraform validate ---"
  terraform validate

  echo "--- terraform plan $extra_args ---"
  eval "terraform plan $extra_args"

  echo "--- terraform apply $extra_args ---"
  eval "terraform apply -auto-approve $extra_args"

  echo "--- terraform destroy $extra_args ---"
  eval "terraform destroy -auto-approve $extra_args"

  echo "Lab '$name' terminé."
  cd - > /dev/null
}

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

# Lab principal - variables par défaut
run_lab "$BASEDIR" "09 : Variables (défaut)"

# Sous-labs
run_lab "$BASEDIR/09-01-Terraform-Variables-tfvars"         "09-01 : Variables tfvars"
run_lab "$BASEDIR/09-02-Terraform-Variables-tfvars-var-file" "09-02 : Variables var-file" \
        "-var-file=dev.tfvars"
run_lab "$BASEDIR/09-03-Terraform-Variables-list"           "09-03 : Variables list"
run_lab "$BASEDIR/09-04-Terraform-Variables-map"            "09-04 : Variables map"
run_lab "$BASEDIR/09-05-Custom-Validation-Rules"            "09-05 : Custom Validation Rules"
run_lab "$BASEDIR/09-06-Sensitive-Variables"                "09-06 : Sensitive Variables"

echo ""
echo "======================================================"
echo "  Tous les labs 09 terminés avec succès !"
echo "======================================================"
