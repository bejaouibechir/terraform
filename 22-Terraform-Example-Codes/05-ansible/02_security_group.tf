resource "aws_security_group" "web" {
  name        = "terraform-ansible-sg"
  description = "Security Group pour l'integration Terraform + Ansible"

  # SSH — nécessaire pour Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH pour Ansible"
  }

  # HTTP — serveur web installé par Ansible
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ansible-sg"
  }
}
