# VPC module for the dev environment
module "vpc_dev" {
  source = "./modules/vpc"

  vpc_name          = "MyVPC-Dev"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# EC2 module composed with the dev VPC subnet
module "ec2_dev" {
  source = "./modules/ec2"

  ami_id        = "ami-1234567890abcdef0"
  instance_type = "t2.micro"
  subnet_id     = module.vpc_dev.subnet_id

  tags = {
    Name        = "MyEC2-Dev"
    Environment = "dev"
  }
}

# S3 module composed with the same environment
module "s3_dev" {
  source = "./modules/s3"

  bucket_name        = "terraform-modules-dev-demo-bucket"
  versioning_enabled = true

  tags = {
    Environment = "dev"
  }
}
