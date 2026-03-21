resource "aws_vpc" "myvpc" {
  # Le CIDR est sélectionné dynamiquement selon le workspace actif
  cidr_block = lookup(var.vpc_cidr, terraform.workspace, "10.0.0.0/16")

  tags = {
    Name = "MyVPC-${terraform.workspace}"
  }
}
