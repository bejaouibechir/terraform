#!/bin/bash
# ######################################################
# Lab : 08 - Terraform Resource Meta-Arguments
# Ce script itère sur chaque sous-lab indépendamment
# ######################################################

run_lab() {
  local dir=$1
  local name=$2
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

  echo "--- terraform plan ---"
  terraform plan

  echo "--- terraform apply ---"
  terraform apply -auto-approve

  echo "--- terraform state list ---"
  terraform state list

  echo "--- terraform destroy ---"
  terraform destroy -auto-approve

  echo "Lab '$name' terminé."
  cd - > /dev/null
}

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

run_lab "$BASEDIR/08-01-count"                          "08-01 : count"
run_lab "$BASEDIR/08-02-for_each/01-for_each-map"       "08-02a : for_each (map)"
run_lab "$BASEDIR/08-02-for_each/02-for_each-set"       "08-02b : for_each (set)"
run_lab "$BASEDIR/08-03-depends_on"                     "08-03 : depends_on"
run_lab "$BASEDIR/08-04-provider"                       "08-04 : provider"
run_lab "$BASEDIR/08-05-lifecycle/01-create_before_destroy" "08-05a : lifecycle - create_before_destroy"

echo ""
echo "======================================================"
echo "  Tous les labs 08 terminés avec succès !"
echo "======================================================"
