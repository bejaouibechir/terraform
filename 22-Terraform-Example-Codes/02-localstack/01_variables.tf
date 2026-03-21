variable "aws_region" {
  description = "Région AWS simulée par LocalStack"
  type        = string
  default     = "us-east-1"
}

variable "localstack_endpoint" {
  description = "URL de l'endpoint LocalStack"
  type        = string
  default     = "http://localhost:4566"
}

variable "bucket_name" {
  description = "Nom du bucket S3 simulé dans LocalStack"
  type        = string
  default     = "tf-localstack-demo-bucket"
}
