resource "aws_s3_bucket" "testS3" {
  bucket = "sujate-terraform-test-bucket"
  acl    = "private"

  versioning {
      enabled = true
  }

  lifecycle_rule {
    prefix = "image/"
    enabled = true

    noncurrent_version_expiration {
      days = 180
    }
  }
  
  tags = {
    "Name" = "sujae-test-bucket"
  }
}
