output "ec2_public_ip" {
  description = "IP publique de l'instance EC2"
  value       = aws_instance.web.public_ip
}

output "ec2_public_dns" {
  description = "DNS public de l'instance EC2"
  value       = aws_instance.web.public_dns
}

output "ec2_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.web.id
}

output "web_url" {
  description = "URL du serveur web installé par Ansible"
  value       = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  description = "Commande SSH pour se connecter à l'instance"
  value       = "ssh -i ${var.private_key_path} ${var.ansible_user}@${aws_instance.web.public_ip}"
}
