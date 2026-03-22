#!/usr/bin/env bash
# ============================================================
# Étude de Cas 5 - Intégration Terraform + Ansible
# PRÉREQUIS :
#   - Credentials AWS configurés (aws configure)
#   - Key pair SSH dans AWS : terraform-ansible-key
#   - Clé privée : ~/.ssh/terraform-ansible-key.pem (chmod 400)
#   - Ansible installé : pip install ansible
#
# Créer la key pair :
#   aws ec2 create-key-pair --key-name terraform-ansible-key \
#     --query 'KeyMaterial' --output text > ~/.ssh/terraform-ansible-key.pem
#   chmod 400 ~/.ssh/terraform-ansible-key.pem
# ============================================================

# Vérifie qu'Ansible est installé
ansible --version

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# ATTENTION : crée une instance EC2 (des frais AWS s'appliquent)
terraform apply -auto-approve

# Affiche les outputs (IP publique de l'instance EC2)
terraform output

# Affiche l'inventaire Ansible généré automatiquement par Terraform
cat inventory.ini

# Teste l'accès HTTP au serveur web déployé par Ansible
curl -s -o /dev/null -w "HTTP Status : %{http_code}\n" "http://$(terraform output -raw ec2_public_ip)"

# Détruit l'instance EC2 et les ressources associées (nettoyage)
terraform destroy -auto-approve
