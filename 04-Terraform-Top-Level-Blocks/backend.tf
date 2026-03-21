terraform {
  # Backend local — le state est stocké dans terraform.tfstate (même répertoire)
  # C'est le comportement par défaut si aucun backend n'est déclaré
  backend "local" {
    path = "terraform.tfstate"
  }
}
