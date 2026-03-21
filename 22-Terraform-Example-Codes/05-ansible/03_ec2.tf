resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  # Activer l'IP publique pour SSH depuis la machine locale
  associate_public_ip_address = true

  tags = {
    Name = "WebServer-TerraformAnsible"
  }
}

# Générer le fichier d'inventaire Ansible avec l'IP de l'EC2
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"
  content  = <<-EOT
    # Inventaire Ansible généré automatiquement par Terraform
    [webservers]
    ${aws_instance.web.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'

    [all:vars]
    ansible_python_interpreter=/usr/bin/python3
  EOT
}
