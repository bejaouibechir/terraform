# ============================================================
# Lab 06 - Terraform VPC Demo
# ============================================================

# Initialise le répertoire Terraform (télécharge les providers)
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée le VPC et les ressources associées
terraform apply -auto-approve

# Affiche les outputs (IDs des ressources créées)
terraform output

# Inspecte l'état complet de l'infrastructure créée
terraform show

# Détruit toutes les ressources créées (nettoyage)
terraform destroy -auto-approve
