terraform {
  required_version = "~> 1.0.9"

  required_providers {
    aws = "~> 4.0"
  }

  backend "s3" {
    bucket         = "sujae-terraform-tfstate-bucket"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "sujae-terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
