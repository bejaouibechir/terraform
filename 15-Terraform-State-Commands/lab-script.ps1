# ============================================================
# Lab 15 - Terraform State Commands
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Crée les ressources
terraform apply -auto-approve

# Liste toutes les ressources gérées dans le state
terraform state list

# Affiche les détails complets d'une ressource spécifique
terraform state show aws_vpc.myvpc

# Télécharge et affiche le contenu complet du state (format JSON)
terraform state pull

# Inspecte le state dans un format lisible
terraform show

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve
