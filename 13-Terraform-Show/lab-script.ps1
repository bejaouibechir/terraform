# ============================================================
# Lab 13 - Terraform Show
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Sauvegarde le plan dans un fichier binaire
terraform plan -out=monplan.tfplan

# Inspecte le fichier de plan en format lisible (avant apply)
terraform show monplan.tfplan

# Crée les ressources
terraform apply -auto-approve

# Inspecte le state après apply (état réel de l'infrastructure)
terraform show

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve

# Supprime le fichier de plan
Remove-Item -Force monplan.tfplan -ErrorAction SilentlyContinue
