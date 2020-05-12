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


