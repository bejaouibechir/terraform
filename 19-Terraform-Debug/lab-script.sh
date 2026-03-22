#!/usr/bin/env bash
# ============================================================
# Lab 19 - Terraform Debug
# ============================================================

# Active la journalisation au niveau TRACE (très détaillé)
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"

# Génère des logs TRACE pendant l'initialisation
terraform init

# Génère des logs TRACE pendant la validation
terraform validate

# Génère des logs TRACE pendant le plan
terraform plan

# Génère des logs TRACE pendant l'apply
terraform apply -auto-approve

# Affiche le nombre total de lignes dans le fichier de log
wc -l terraform-trace.log

# Affiche les 20 premières lignes du log
head -20 terraform-trace.log

# Recherche les appels API dans les logs
grep "POST\|GET\|PUT" terraform-trace.log | head -10

# Passe le niveau de log à INFO (moins verbeux que TRACE)
export TF_LOG=INFO
terraform refresh

# Désactive complètement la journalisation
unset TF_LOG
unset TF_LOG_PATH

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve

# Supprime les fichiers générés pendant le lab
rm -rf .terraform*
rm -f terraform.tfstate*
rm -f terraform-trace.log
