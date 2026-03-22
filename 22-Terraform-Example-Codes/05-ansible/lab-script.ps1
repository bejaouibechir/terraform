# ============================================================
# Étude de Cas 5 - Intégration Terraform + Ansible
# PRÉREQUIS :
#   - Credentials AWS configurés (aws configure)
#   - Key pair SSH dans AWS : terraform-ansible-key
#   - Clé privée : ~/.ssh/terraform-ansible-key.pem (chmod 400)
#   - Ansible installé : pip install ansible
#   - IMPORTANT : Ansible ne fonctionne pas nativement sous Windows
#     Utilisez WSL2 pour exécuter ce lab
# ============================================================

# Vérifie qu'Ansible est installé (depuis WSL : wsl ansible --version)
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
Get-Content inventory.ini

# Teste l'accès HTTP au serveur web déployé
$ec2Ip = terraform output -raw ec2_public_ip
Invoke-WebRequest -Uri "http://$ec2Ip" -UseBasicParsing

# Détruit l'instance EC2 et les ressources associées (nettoyage)
terraform destroy -auto-approve
