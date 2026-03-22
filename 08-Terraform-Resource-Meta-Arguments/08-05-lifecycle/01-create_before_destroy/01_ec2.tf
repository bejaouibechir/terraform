# lifecycle : create_before_destroy
# Terraform crée la nouvelle ressource AVANT de supprimer l'ancienne
# Utile pour assurer la continuité de service (zéro downtime)
#
# Pour tester :
#   terraform apply        → crée le fichier
#   Modifiez le "prefix" du random_pet (ex: "web" → "app")
#   terraform apply        → nouveau fichier créé avant que l'ancien soit supprimé

resource "random_pet" "server_name" {
  length = 2
  prefix = "web"

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "server_config" {
  filename = "${path.module}/output/server-${random_pet.server_name.id}.conf"
  content  = <<-EOT
    SERVER_NAME=${random_pet.server_name.id}
    STATUS=running
    LIFECYCLE=create_before_destroy
  EOT

  lifecycle {
    create_before_destroy = true
  }
}

output "server_config_path" {
  value = local_file.server_config.filename
}
