# Ressource de base pour simuler un serveur
resource "random_pet" "server_name" {
  length = 2
  prefix = var.environment
}

resource "random_id" "server_id" {
  byte_length = 4
}
