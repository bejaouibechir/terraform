resource "null_resource" "server_provisioner" {
  triggers = {
    server_id = random_id.server_id.hex
  }

  # -------------------------------------------------------
  # Provisioner 1 : local-exec (création)
  # Exécuté localement au moment du terraform apply
  # -------------------------------------------------------
  provisioner "local-exec" {
    command = "echo '[PROVISIONER] Serveur ${random_pet.server_name.id} (${random_id.server_id.hex}) démarré le $(date)' >> ${path.module}/output/provisioner.log"
  }

  # -------------------------------------------------------
  # Provisioner 2 : local-exec (création d'un fichier config)
  # Simule la copie d'un fichier vers un serveur distant
  # -------------------------------------------------------
  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/output
      cat > ${path.module}/output/setup.sh << 'SCRIPT'
#!/bin/bash
echo "Configuration de ${var.app_name} sur ${random_pet.server_name.id}"
echo "Environnement : ${var.environment}"
echo "Propriétaire  : ${var.owner}"
SCRIPT
      chmod +x ${path.module}/output/setup.sh
      echo '[PROVISIONER] Script setup.sh copié avec succès' >> ${path.module}/output/provisioner.log
    EOT
  }

  # -------------------------------------------------------
  # Provisioner 3 : local-exec (exécution du script)
  # Simule remote-exec (dans ce lab, exécution locale)
  # -------------------------------------------------------
  provisioner "local-exec" {
    command = <<-EOT
      bash ${path.module}/output/setup.sh >> ${path.module}/output/provisioner.log 2>&1
      echo '[PROVISIONER] Script exécuté avec succès' >> ${path.module}/output/provisioner.log
    EOT
  }

  # -------------------------------------------------------
  # Provisioner 4 : local-exec when=destroy
  # Exécuté au moment du terraform destroy
  # -------------------------------------------------------
  provisioner "local-exec" {
    when    = destroy
    command = "echo '[DESTROY] Serveur supprimé le $(date)' >> ${path.module}/output/provisioner.log"
  }

  depends_on = [random_pet.server_name, random_id.server_id]
}
