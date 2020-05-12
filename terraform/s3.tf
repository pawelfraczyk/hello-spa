resource "aws_s3_bucket" "custom_bucket" {
  bucket = "${var.project}-${var.stage}-app-bucket"
  acl    = var.custom_bucket_acl

  versioning {
    enabled = var.custom_bucket_versioning_enabled
  }

  website {
    index_document = var.custom_bucket_website_index
    error_document = var.custom_bucket_website_error
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Project     = var.project
    Environment = var.stage
    Terraform   = true
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.custom_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.custom_bucket.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_access_policy" {
  bucket = aws_s3_bucket.custom_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
