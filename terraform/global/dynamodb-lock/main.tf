provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "locking_terraform_statefile" {
  name = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute { 
    name = "LockID"
    type = "S"
  }

  tags = { 
    Name = "Terraform Lock Table"
    Environment = "global"
  }
}
