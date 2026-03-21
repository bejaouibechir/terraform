# Étape 1 - Déclaration vide avant l'import
# (bloc vide requis avant d'exécuter terraform import)
#
# resource "aws_vpc" "imported" {
#
# }

# Étape 2 - Configuration complète après l'import et terraform show
# (à renseigner manuellement après avoir exécuté terraform show)
resource "aws_vpc" "imported" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false
  instance_tenancy     = "default"

  tags = {
    Name = "MyVPC-Existing"
  }
}
