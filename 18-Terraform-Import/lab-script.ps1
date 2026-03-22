# ============================================================
# Lab 18 - Terraform Import
# IMPORTANT : remplacez VPC_ID par l'ID réel de votre VPC existant
#             ex : vpc-0ab12cd34ef567890
# ============================================================

# Remplacez par l'ID de votre VPC existant
$VPC_ID = "vpc-XXXXXXXXXXXXXXXXX"

# Initialise le répertoire Terraform
terraform init

# Formate les fichiers .tf
terraform fmt

# Vérifie la syntaxe des fichiers .tf
terraform validate

# Assurez-vous que 02_vpc.tf contient un bloc vide :
#   resource "aws_vpc" "imported" {}
# puis importez le VPC existant dans le state Terraform
terraform import aws_vpc.imported $VPC_ID

# Inspectez les attributs du VPC importé
# Puis mettez à jour 02_vpc.tf avec ces attributs pour correspondre au state
terraform show

# Après mise à jour de 02_vpc.tf, vérifiez qu'aucun changement n'est détecté
terraform plan

# Confirme la gestion Terraform du VPC importé
terraform apply -auto-approve

terraform output

# NOTE : utilisez 'terraform destroy' si vous souhaitez supprimer le VPC importé
