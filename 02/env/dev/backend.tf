terraform {
  backend "s3" {
    bucket         = "sujae-terraform-tfstate-bucket"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "sujae-terraform-lock"
    encrypt        = true
  }
}
