resource "aws_s3_bucket" "s3" {
  bucket = "sujae-${var.env}-terraform-bucket"
}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}
resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {
  bucket = aws_s3_bucket.s3.id

  rule {
    id = "img"

    expiration {
      days = 180
    }

    filter {
      prefix = "image/"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Disabled"
  }
}


data "aws_iam_policy_document" "allow_access_from_endpoint_doc" {
  statement {
    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    sid = "allow-access-from-endpoint"

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::sujae-${var.env}-terraform-bucket",
      "arn:aws:s3:::sujae-${var.env}-terraform-bucket/*"
    ]

    condition {
      test = "StringEquals"

      variable = "aws:SourceVpce"

      values = [
        var.endpoint_id
      ]
    }
  }

}
resource "aws_s3_bucket_policy" "allow_access_from_endpoint" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.allow_access_from_endpoint_doc.json
}
