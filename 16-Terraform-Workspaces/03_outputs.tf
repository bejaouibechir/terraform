output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.myvpc.id
}

output "vpc_cidr" {
  description = "CIDR du VPC créé"
  value       = aws_vpc.myvpc.cidr_block
}

output "workspace_actif" {
  description = "Nom du workspace Terraform actif"
  value       = terraform.workspace
}
