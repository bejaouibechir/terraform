output "nginx_container_id" {
  description = "ID du conteneur Nginx"
  value       = docker_container.nginx.id
}

output "nginx_url" {
  description = "URL pour accéder à Nginx"
  value       = "http://localhost:${var.nginx_external_port}"
}

output "redis_container_id" {
  description = "ID du conteneur Redis"
  value       = docker_container.redis.id
}

output "redis_endpoint" {
  description = "Endpoint Redis"
  value       = "localhost:${var.redis_external_port}"
}

output "network_name" {
  description = "Nom du réseau Docker créé"
  value       = docker_network.main.name
}
