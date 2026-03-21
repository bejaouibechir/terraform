output "vpc_id" {
  description = "ID du VPC importé"
  value       = aws_vpc.imported.id
}

output "vpc_cidr" {
  description = "CIDR du VPC importé"
  value       = aws_vpc.imported.cidr_block
}

output "vpc_arn" {
  description = "ARN du VPC importé"
  value       = aws_vpc.imported.arn
}
