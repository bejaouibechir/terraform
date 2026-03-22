# lifecycle : prevent_destroy
# Terraform refuse de détruire cette ressource tant que prevent_destroy = true
# Protège les ressources critiques contre une suppression accidentelle
#
# Pour tester :
#   terraform apply             → crée le fichier
#   terraform destroy           → ERREUR : prevent_destroy bloque la suppression
#   Commentez le bloc lifecycle, relancez terraform destroy → fonctionne

resource "random_pet" "critical_name" {
  length = 2
  prefix = "critical"
}

resource "local_file" "critical_config" {
  filename = "${path.module}/output/critical.conf"
  content  = <<-EOT
    SERVER_NAME=${random_pet.critical_name.id}
    CRITICAL=true
    DO_NOT_DELETE=yes
    LIFECYCLE=prevent_destroy
  EOT

  lifecycle {
    prevent_destroy = true
  }
}

output "critical_config_path" {
  value = local_file.critical_config.filename
}
