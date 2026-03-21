terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuration du provider AWS pour LocalStack
# LocalStack simule AWS localement sur http://localhost:4566
provider "aws" {
  region = var.aws_region

  # Credentials factices — LocalStack n'effectue pas de vraie validation
  access_key = "test"
  secret_key = "test"

  # Désactiver les validations AWS réelles
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  # Rediriger tous les appels API vers LocalStack
  endpoints {
    ec2 = var.localstack_endpoint
    s3  = var.localstack_endpoint
  }
}
