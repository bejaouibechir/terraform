#!/usr/bin/env bash
# ============================================================
# Lab 20 - Terraform Provisioners
# PRÉREQUIS :
#   1. Key pair AWS nommée "terraform-demo" (région us-east-1)
#   2. Clé privée disponible : ~/.ssh/id_rsa (chmod 400)
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les ressources — observez dans les logs l'exécution des provisioners :
#   - local-exec  : écriture locale dans ec2-info.txt
#   - file        : copie de scripts/setup.sh sur l'instance
#   - remote-exec : installation Apache via SSH
terraform apply -auto-approve

# Vérifie le fichier créé localement par le provisioner local-exec
cat ec2-info.txt

# Affiche l'URL du site web déployé
terraform output

# Inspecte l'état complet de l'infrastructure
terraform show

# Détruit les ressources — le provisioner when=destroy s'exécute avant la destruction
terraform destroy -auto-approve

# Vérifie ec2-info.txt après destruction (provisioner local-exec when=destroy)
cat ec2-info.txt
