# Meta-argument COUNT
# Crée 3 fichiers de configuration identiques numérotés
# Équivaut à créer 3 instances EC2 avec count = 3

resource "local_file" "server" {
  count    = 3
  filename = "${path.module}/output/server-${count.index}.conf"
  content  = <<-EOT
    # Serveur ${count.index}
    SERVER_ID=${count.index}
    SERVER_NAME=server-${count.index}
    ENVIRONMENT=dev
  EOT
}

output "server_files" {
  description = "Liste des fichiers créés par count"
  value       = local_file.server[*].filename
}

output "first_server" {
  description = "Premier serveur (index 0)"
  value       = local_file.server[0].filename
}
