output "hello_file_path" {
  description = "Chemin du fichier hello.txt généré"
  value       = local_file.hello.filename
}

output "config_file_path" {
  description = "Chemin du fichier config.json généré"
  value       = local_sensitive_file.config.filename
}

output "inventory_file_path" {
  description = "Chemin du fichier d'inventaire Ansible généré"
  value       = local_file.inventory.filename
}
