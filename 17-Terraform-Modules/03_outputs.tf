output "vpc_dev_id" {
  description = "ID du VPC Dev"
  value       = module.vpc_dev.vpc_id
}

output "vpc_prod_id" {
  description = "ID du VPC Prod"
  value       = module.vpc_prod.vpc_id
}
