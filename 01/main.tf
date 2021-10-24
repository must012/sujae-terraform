terraform {
  required_version = "1.0.9"

  required_providers {
    aws = "~> 3.0"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
