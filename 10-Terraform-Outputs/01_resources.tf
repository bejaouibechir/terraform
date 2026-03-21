resource "random_pet" "server_name" {
  length = 2
  prefix = "srv"
}

resource "random_integer" "port" {
  min = 8000
  max = 9000
}

resource "random_password" "api_key" {
  length  = 32
  special = false
}

# Génération d'une clé TLS — démontre un output de type objet complexe
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "connection_info" {
  filename = "${path.module}/output/connection.txt"
  content  = <<-EOT
    Serveur  : ${random_pet.server_name.id}
    Port     : ${random_integer.port.result}
    Endpoint : http://${random_pet.server_name.id}:${random_integer.port.result}
  EOT
}
