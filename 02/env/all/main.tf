terraform {
  required_version = "~> 1.0.9"

  required_providers {
    aws = "~> 4.0"
  }
}

# S3 생성 코드
resource "aws_s3_bucket" "tfstate"{
 bucket = "sujae-terraform-tfstate-bucket"

 versioning {
  enabled = true
 }
}

# DynamoDB 생성 코드
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "sujae-terraform-lock"
  hash_key       = "LockID"
  read_capacity = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }
}