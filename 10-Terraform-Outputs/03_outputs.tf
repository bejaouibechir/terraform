# Output simple — string
output "server_name" {
  description = "Nom du serveur généré"
  value       = random_pet.server_name.id
}

# Output numérique
output "server_port" {
  description = "Port d'écoute du serveur"
  value       = random_integer.port.result
}

# Output construit (interpolation)
output "server_endpoint" {
  description = "URL complète du serveur"
  value       = "http://${random_pet.server_name.id}:${random_integer.port.result}"
}

# Output sensible — masqué dans les logs terraform apply
output "api_key" {
  description = "Clé API générée (sensible — masquée dans les logs)"
  value       = random_password.api_key.result
  sensitive   = true
}

# Output de type string multi-lignes (clé publique SSH)
output "ssh_public_key" {
  description = "Clé publique SSH générée par le provider TLS"
  value       = tls_private_key.ssh_key.public_key_openssh
}

# Output de type objet
output "server_info" {
  description = "Informations complètes du serveur (objet)"
  value = {
    name        = random_pet.server_name.id
    port        = random_integer.port.result
    environment = var.environment
    owner       = var.owner
  }
}
