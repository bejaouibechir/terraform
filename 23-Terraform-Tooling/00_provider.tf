terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  description = "AWS region used by the provider."
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

