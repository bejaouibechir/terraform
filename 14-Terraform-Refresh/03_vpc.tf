resource "random_pet" "infra_name" {
  length = 2
  prefix = var.environment
}

# Ce fichier sera créé par Terraform puis modifié manuellement
# pour démontrer terraform refresh (détection de dérive)
resource "local_file" "infra_config" {
  filename = "${path.module}/output/infra.conf"
  content  = <<-EOT
    # Configuration gérée par Terraform
    # OWNER=${var.owner}
    # ENV=${var.environment}
    INFRA_NAME=${random_pet.infra_name.id}
    STATUS=active
    MANAGED_BY=terraform
  EOT
}
