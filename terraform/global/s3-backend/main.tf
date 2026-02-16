provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terra_state_example1" {
  bucket = "company-terraform-state-example1"
  force_destroy = true

  tags = {
    Name = "Terraform State bucket"
    Environment = "global"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terra_state_example1.id

  versioning_configuration {
    status = "Enabled"
  }
}

