# Variables sensibles — démontre sensitive = true
# Les valeurs ne s'affichent pas dans les logs terraform apply/output

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%"
}

resource "local_sensitive_file" "db_config" {
  filename = "${path.module}/output/db.conf"
  content  = <<-EOT
    DB_HOST=localhost
    DB_USER=${var.db_username}
    DB_PASSWORD=${var.db_password != "" ? var.db_password : random_password.db_password.result}
    DB_NAME=myapp
  EOT
}

output "db_password_generated" {
  description = "Mot de passe généré (sensible — masqué dans les logs)"
  value       = random_password.db_password.result
  sensitive   = true
}
