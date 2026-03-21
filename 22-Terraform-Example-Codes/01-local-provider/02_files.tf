resource "local_file" "hello" {
  filename = "${var.output_dir}/hello.txt"
  content  = <<-EOT
    Bonjour depuis Terraform !
    Environnement : ${var.environment}
    Auteur        : ${var.author}
    Provider      : hashicorp/local
  EOT
}

resource "local_sensitive_file" "config" {
  filename = "${var.output_dir}/config.json"
  content = jsonencode({
    environment = var.environment
    author      = var.author
    managed_by  = "Terraform"
    provider    = "hashicorp/local"
  })
}

resource "local_file" "inventory" {
  filename = "${var.output_dir}/inventory.ini"
  content  = <<-EOT
    # Inventaire Ansible généré par Terraform
    # Environnement : ${var.environment}

    [webservers]
    # Remplacez par les IPs réelles de vos serveurs
    192.168.1.10 ansible_user=ec2-user
    192.168.1.11 ansible_user=ec2-user

    [all:vars]
    ansible_ssh_private_key_file=~/.ssh/id_rsa
  EOT
}
