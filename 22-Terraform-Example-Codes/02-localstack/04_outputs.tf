output "vpc_id" {
  description = "ID du VPC simulé par LocalStack"
  value       = aws_vpc.myvpc.id
}

output "subnet_id" {
  description = "ID du Subnet simulé par LocalStack"
  value       = aws_subnet.mysubnet.id
}

output "bucket_name" {
  description = "Nom du bucket S3 simulé"
  value       = aws_s3_bucket.demo.bucket
}

output "bucket_arn" {
  description = "ARN du bucket S3 simulé"
  value       = aws_s3_bucket.demo.arn
}
