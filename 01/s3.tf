resource "aws_s3_bucket" "testS3" {
  bucket = "sujate-terraform-test-bucket"
  acl    = "private"

  versioning {
      enabled = true
  }
  tags = {
    "Name" = "sujae-test-bucket"
  }
}
