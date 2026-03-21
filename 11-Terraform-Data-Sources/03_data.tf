# -------------------------------------------------------
# Data Source 1 : appel HTTP vers une API publique
# Simule la récupération d'informations externes
# comme "data aws_ami" ou "data aws_availability_zones"
# -------------------------------------------------------
data "http" "public_ip" {
  url = "https://api.ipify.org?format=json"

  request_headers = {
    Accept = "application/json"
  }
}

# -------------------------------------------------------
# Data Source 2 : lecture d'un fichier local existant
# Simule "data aws_vpc" — interroger une ressource existante
# -------------------------------------------------------
data "local_file" "existing_config" {
  filename = "${path.module}/existing_config.json"
}
