#!/usr/bin/env bash
# ============================================================
# Lab 12 - Terraform State
# Exécuter depuis : 12-Terraform-State/
#
# PRÉREQUIS (Option B — State distant) :
#   - Bucket S3      : "tf-aws-backend" dans us-east-1
#   - Dossier S3     : "tf/dev/"
#   - Table DynamoDB : "tf-dev-state-lock" (clé : LockID)
# ============================================================

# ── Option A : State LOCAL ───────────────────────────────────
cd tf-state-demo-files/local

terraform init
terraform fmt
terraform validate
terraform apply -auto-approve

# Le fichier terraform.tfstate est stocké localement dans ce répertoire
ls -lh terraform.tfstate

terraform destroy -auto-approve
cd ../..

# ── Option B : State DISTANT (S3 + DynamoDB) ─────────────────
# Notez dans les logs l'acquisition du verrou DynamoDB

terraform init
terraform fmt
terraform validate

# Observez "Acquiring state lock" dans la sortie
terraform plan

# Observez "Acquiring state lock" et "Releasing state lock"
terraform apply -auto-approve

# Liste les ressources dans le state distant
terraform state list

# Affiche les détails d'une ressource spécifique depuis le state distant
terraform state show aws_vpc.myvpc

# Télécharge et affiche le contenu complet du state (JSON)
terraform state pull

terraform destroy -auto-approve
