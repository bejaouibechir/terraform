terraform {
  # Backend local — state stocké dans terraform.tfstate
  backend "local" {
    path = "terraform.tfstate"
  }
}
