output "vpc_dev_id" {
  description = "ID du VPC Dev"
  value       = module.vpc_dev.vpc_id
}

output "ec2_dev_instance_id" {
  description = "ID of the dev EC2 instance."
  value       = module.ec2_dev.instance_id
}

output "ec2_dev_public_ip" {
  description = "Public IP address of the dev EC2 instance."
  value       = module.ec2_dev.public_ip
}

output "s3_dev_bucket_id" {
  description = "ID of the dev S3 bucket."
  value       = module.s3_dev.bucket_id
}

output "s3_dev_bucket_arn" {
  description = "ARN of the dev S3 bucket."
  value       = module.s3_dev.bucket_arn
}
