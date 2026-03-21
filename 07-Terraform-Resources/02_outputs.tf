output "app_id" {
  description = "ID unique de l'application"
  value       = random_id.app_id.hex
}

output "db_password" {
  description = "Mot de passe base de données (sensible)"
  value       = random_password.db_password.result
  sensitive   = true
}

output "config_path" {
  description = "Chemin du fichier de configuration"
  value       = local_file.app_config.filename
}
