output "server_name" {
  description = "Nom du serveur"
  value       = random_pet.server.id
}

output "database_name" {
  description = "Nom de la base de données"
  value       = random_pet.database.id
}

output "network_id" {
  description = "ID du réseau"
  value       = random_id.network_id.hex
}
