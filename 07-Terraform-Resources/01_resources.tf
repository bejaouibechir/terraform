# -------------------------------------------------------
# Dépendance IMPLICITE
# random_id est créé en premier car local_file le référence
# Terraform détecte cette dépendance automatiquement
# -------------------------------------------------------
resource "random_id" "app_id" {
  byte_length = 6
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%"
}

# Ce fichier dépend implicitement de random_id.app_id et random_password.db_password
resource "local_file" "app_config" {
  filename = "${path.module}/output/app.json"
  content = jsonencode({
    app_id      = random_id.app_id.hex
    environment = "production"
    database = {
      host     = "db.example.com"
      port     = 5432
      password = random_password.db_password.result
    }
  })
}

# -------------------------------------------------------
# Dépendance EXPLICITE via depends_on
# Ce fichier ne sera créé qu'après app_config
# -------------------------------------------------------
resource "local_file" "app_readme" {
  filename = "${path.module}/output/README.txt"
  content  = "Application ${random_id.app_id.hex} déployée par Terraform."

  depends_on = [local_file.app_config]
}
