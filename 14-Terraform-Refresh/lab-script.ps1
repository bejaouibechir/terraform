# ============================================================
# Lab 14 - Terraform Refresh
# ============================================================

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Calcule et affiche le plan de déploiement
terraform plan

# Crée les ressources
terraform apply -auto-approve

# Inspecte le state AVANT refresh
terraform show

# Synchronise le state avec l'infrastructure réelle
# NOTE : pour observer le comportement, ajoutez manuellement un tag
#        sur le VPC depuis la Console AWS avant cette commande
terraform refresh

# Inspecte le state APRÈS refresh (le nouveau tag doit apparaître)
terraform show

# Vérifie si des différences sont détectées entre state et code
terraform plan

# Détruit toutes les ressources (nettoyage)
terraform destroy -auto-approve
