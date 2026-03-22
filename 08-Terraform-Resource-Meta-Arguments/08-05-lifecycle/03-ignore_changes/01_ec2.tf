# lifecycle : ignore_changes
# Terraform ignore les modifications sur les champs spécifiés
# Utile quand une ressource est modifiée hors Terraform (ex: pipeline CI/CD)
#
# Pour tester :
#   terraform apply                    → crée le fichier
#   Modifiez manuellement output/managed.conf
#   terraform plan                     → aucun changement détecté sur "content"
#   Supprimez l'ignore_changes, relancez terraform plan → changement détecté

resource "random_pet" "server_name" {
  length = 2
  prefix = "managed"
}

resource "local_file" "managed_config" {
  filename = "${path.module}/output/managed.conf"
  content  = <<-EOT
    SERVER_NAME=${random_pet.server_name.id}
    VERSION=1.0
    LIFECYCLE=ignore_changes
  EOT

  lifecycle {
    ignore_changes = [content]
  }
}

output "managed_config_path" {
  value = local_file.managed_config.filename
}

output "server_name" {
  value = random_pet.server_name.id
}
