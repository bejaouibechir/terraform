output "server_name" {
  description = "Nom du serveur provisionné"
  value       = random_pet.server_name.id
}

output "server_id" {
  description = "ID unique du serveur"
  value       = random_id.server_id.hex
}

output "provisioner_log" {
  description = "Chemin du journal des provisioners"
  value       = "${path.module}/output/provisioner.log"
}
