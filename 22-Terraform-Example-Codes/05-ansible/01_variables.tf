variable "aws_region" {
  description = "Région AWS pour créer les ressources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI Amazon Linux 2023 pour us-east-1"
  type        = string
  default     = "ami-0453ec754f44f9a4a" # Amazon Linux 2023 — us-east-1
}

variable "key_name" {
  description = "Nom de la key pair SSH dans AWS"
  type        = string
  default     = "terraform-ansible-key"
}

variable "private_key_path" {
  description = "Chemin vers la clé privée SSH locale"
  type        = string
  default     = "~/.ssh/terraform-ansible-key.pem"
}

variable "ansible_user" {
  description = "Utilisateur SSH pour Ansible (ec2-user pour Amazon Linux)"
  type        = string
  default     = "ec2-user"
}
