resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  tags = {
    Name      = "LocalStack Demo Bucket"
    Simulator = "LocalStack"
  }
}

resource "aws_s3_object" "readme" {
  bucket  = aws_s3_bucket.demo.id
  key     = "README.txt"
  content = "Ce bucket a été créé par Terraform via LocalStack."
}
