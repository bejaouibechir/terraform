# -------------------------------------------------------
# Bloc variable — entrée paramétrable
# -------------------------------------------------------
variable "environment" {
  description = "Nom de l'environnement"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "terraform-demo"
}

# -------------------------------------------------------
# Bloc locals — valeurs calculées localement
# -------------------------------------------------------
locals {
  prefix    = "${var.project_name}-${var.environment}"
  timestamp = formatdate("YYYY-MM-DD", timestamp())
}

# -------------------------------------------------------
# Bloc resource — ressource gérée par Terraform
# -------------------------------------------------------
resource "random_id" "project_id" {
  byte_length = 4
}

resource "local_file" "config" {
  filename = "${path.module}/output/config.txt"
  content  = <<-EOT
    Projet    : ${local.prefix}
    ID unique : ${random_id.project_id.hex}
    Date      : ${local.timestamp}
    Environnement : ${var.environment}
  EOT
}

# -------------------------------------------------------
# Bloc data — lecture d'une ressource existante
# -------------------------------------------------------
data "local_file" "readme" {
  filename = "${path.module}/../../README.md"
}

# -------------------------------------------------------
# Bloc output — valeurs exposées après apply
# -------------------------------------------------------
output "project_id" {
  description = "ID unique généré pour ce projet"
  value       = random_id.project_id.hex
}

output "config_path" {
  description = "Chemin du fichier de configuration généré"
  value       = local_file.config.filename
}

output "prefix" {
  description = "Préfixe calculé par locals"
  value       = local.prefix
}
