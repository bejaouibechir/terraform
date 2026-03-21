output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID du Subnet créé"
  value       = aws_subnet.this.id
}
