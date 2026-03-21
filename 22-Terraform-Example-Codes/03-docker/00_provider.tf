terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Le provider Docker se connecte au daemon Docker local
# Sur Linux/Mac : socket Unix /var/run/docker.sock
# Sur Windows   : npipe:////./pipe/docker_engine
provider "docker" {
  # Décommentez la ligne suivante si Docker Desktop est sur Windows
  # host = "npipe:////./pipe/docker_engine"
}
