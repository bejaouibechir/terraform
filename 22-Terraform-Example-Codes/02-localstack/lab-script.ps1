# ============================================================
# Étude de Cas 2 - LocalStack (Simulateur AWS Local)
# PRÉREQUIS :
#   - Docker démarré
#   - LocalStack en cours d'exécution : docker start localstack-main
# ============================================================

# Vérifie que LocalStack est démarré et opérationnel
Invoke-RestMethod http://localhost:4566/_localstack/health

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les ressources AWS simulées par LocalStack
terraform apply -auto-approve

# Affiche les outputs (IDs des ressources créées)
terraform output

# Vérifie les ressources créées via awslocal (pip install awscli-local)
awslocal ec2 describe-vpcs --output table
awslocal s3 ls

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve
