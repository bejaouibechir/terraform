output "public_ip" {
  description = "IP publique récupérée via data source HTTP"
  value       = jsondecode(data.http.public_ip.response_body).ip
}

output "existing_config" {
  description = "Contenu du fichier de configuration existant (data source local)"
  value       = jsondecode(data.local_file.existing_config.content)
}

output "instance_id" {
  description = "ID de l'instance générée"
  value       = random_id.instance_id.hex
}
