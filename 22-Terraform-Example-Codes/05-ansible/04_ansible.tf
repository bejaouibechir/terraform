resource "null_resource" "ansible_provisioner" {
  # Re-provisionner si l'instance change
  triggers = {
    instance_id = aws_instance.web.id
  }

  # Attendre que SSH soit disponible avant de lancer Ansible
  provisioner "local-exec" {
    command = <<-EOF
      echo "Attente de disponibilité SSH sur ${aws_instance.web.public_ip}..."
      timeout 120 bash -c 'until nc -z ${aws_instance.web.public_ip} 22; do sleep 5; done'
      echo "SSH disponible ! Lancement du playbook Ansible..."
      ansible-playbook -i ${path.module}/inventory.ini ${path.module}/playbook.yml
    EOF
  }

  depends_on = [
    aws_instance.web,
    local_file.ansible_inventory
  ]
}
