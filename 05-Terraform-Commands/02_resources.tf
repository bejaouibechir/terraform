resource "random_pet" "server_name" {
  length    = 2
  separator = "-"
  prefix    = var.environment
}

resource "random_id" "unique_id" {
  byte_length = 4
}

resource "local_file" "server_config" {
  filename = "${path.module}/output/server.conf"
  content  = <<-EOT
    # Configuration générée par Terraform
    # Commande : terraform apply
    SERVER_NAME=${random_pet.server_name.id}
    SERVER_ID=${random_id.unique_id.hex}
    ENVIRONMENT=${var.environment}
    PROJECT=${var.project}
  EOT
}
