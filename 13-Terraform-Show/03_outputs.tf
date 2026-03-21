output "resource_name" {
  description = "Nom de la ressource générée"
  value       = random_pet.name.id
}

output "resource_id" {
  description = "ID unique de la ressource"
  value       = random_id.id.hex
}

output "config_path" {
  description = "Chemin du fichier de configuration"
  value       = local_file.config.filename
}
