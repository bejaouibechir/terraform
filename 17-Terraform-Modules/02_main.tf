# Appel du module VPC pour l'environnement dev
module "vpc_dev" {
  source = "./modules/vpc"

  vpc_name          = "MyVPC-Dev"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Appel du module VPC pour l'environnement prod
module "vpc_prod" {
  source = "./modules/vpc"

  vpc_name          = "MyVPC-Prod"
  vpc_cidr          = "10.1.0.0/16"
  subnet_cidr       = "10.1.1.0/24"
  availability_zone = "us-east-1b"
}
