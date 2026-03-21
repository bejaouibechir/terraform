output "server_name" {
  description = "Nom du serveur généré aléatoirement"
  value       = random_pet.server_name.id
}

output "unique_id" {
  description = "ID unique hexadécimal"
  value       = random_id.unique_id.hex
}

output "config_file" {
  description = "Chemin du fichier de configuration généré"
  value       = local_file.server_config.filename
}
