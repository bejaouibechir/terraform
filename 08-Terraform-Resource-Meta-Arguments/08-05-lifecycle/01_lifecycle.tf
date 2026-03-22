# -------------------------------------------------------
# lifecycle : create_before_destroy
# Terraform crée le nouveau fichier AVANT de supprimer l'ancien
# Utile pour les ressources sans downtime
# -------------------------------------------------------
resource "random_pet" "server_name" {
  length = 2

  lifecycle {
    create_before_destroy = true
  }
}

# -------------------------------------------------------
# lifecycle : ignore_changes
# Terraform ignore les modifications sur le champ "content"
# Utile quand une ressource est modifiée hors Terraform
# -------------------------------------------------------
resource "local_file" "managed_config" {
  filename = "${path.module}/output/managed.conf"
  content  = "SERVER=${random_pet.server_name.id}\nVERSION=1.0"

  lifecycle {
    ignore_changes = [content]
  }
}

# -------------------------------------------------------
# lifecycle : prevent_destroy
# Terraform refusera de détruire cette ressource
# Décommentez pour tester : terraform destroy échouera
# -------------------------------------------------------
resource "local_file" "critical_config" {
  filename = "${path.module}/output/critical.conf"
  content  = "CRITICAL=true\nDO_NOT_DELETE=yes"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

output "server_name" {
  value = random_pet.server_name.id
}
