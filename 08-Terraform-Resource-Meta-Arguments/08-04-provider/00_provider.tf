terraform {
  required_version = "~> 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Meta-argument PROVIDER — deux providers aliasés
# Simule deux régions AWS (eu-west-1 et ap-south-1)

provider "local" {
  alias = "project-europe"
}

provider "local" {
  alias = "project-asia"
}
