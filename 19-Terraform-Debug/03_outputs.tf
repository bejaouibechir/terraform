output "resource_name" {
  description = "Nom de la ressource créée"
  value       = random_pet.resource_name.id
}

output "resource_id" {
  description = "ID unique de la ressource"
  value       = random_id.resource_id.hex
}
