terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---------------------------------------------------------------------------
# Provider AWS — LocalStack (simulation locale, aucune credential AWS réelle)
# LocalStack doit être lancé : docker run -d -p 4566:4566 localstack/localstack
# ---------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region

  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    ec2      = "http://localhost:4566"
    s3       = "http://localhost:4566"
    iam      = "http://localhost:4566"
    sts      = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
  }

  default_tags {
    tags = {
      Terraform = "yes"
      Owner     = var.owner
    }
  }
}
