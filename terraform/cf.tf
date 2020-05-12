locals {
  app_origin_id = "${var.project}-${var.stage}-origin"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.project}-${var.stage} origin access identity"
}

resource "aws_cloudfront_distribution" "default_distribution" {
  origin {
    domain_name = aws_s3_bucket.custom_bucket.bucket_regional_domain_name
    origin_id   = local.app_origin_id

    custom_origin_config {
      http_port                = var.cf_origin_http_port
      https_port               = var.cf_origin_https_port
      origin_ssl_protocols     = var.cf_origin_ssl_protocols
      origin_protocol_policy   = var.cf_origin_protocol_policy
      origin_keepalive_timeout = var.cf_origin_keepalive_timeout
      origin_read_timeout      = var.cf_origin_keepalive_timeout
    }
  }

  enabled             = var.cf_enabled
  is_ipv6_enabled     = var.cf_is_ipv6_enabled
  default_root_object = var.cf_default_root_object
  aliases = [
    "${var.domain}",
    "*.${var.domain}"
  ]

  default_cache_behavior {
    allowed_methods  = var.cf_default_cache_behavior_allowed_methods
    cached_methods   = var.cf_default_cache_behavior_cached_methods
    target_origin_id = local.app_origin_id

    forwarded_values {
      query_string = var.cf_default_cache_behavior_forwarded_values_query_string
      headers      = var.cf_default_cache_behavior_forwarded_values_headsers

      cookies {
        forward = var.cf_default_cache_behavior_forwarded_values_cookies_forward
      }
    }


    min_ttl                = var.cf_default_cache_behavior_min_ttl
    default_ttl            = var.cf_default_cache_behavior_default_ttl
    max_ttl                = var.cf_default_cache_behavior_max_ttl
    compress               = var.cf_default_cache_behavior_compress
    viewer_protocol_policy = var.cf_default_cache_behavior_viewer_protocol_policy
  }

  price_class = var.cf_price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cf_geo_restriction
      locations        = var.cf_geo_restriction_locations
    }
  }

  tags = {
    Project     = var.project
    Environment = var.stage
    Terraform   = true
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cf_default_certificate
    acm_certificate_arn            = aws_acm_certificate.cdn_cert.arn
    ssl_support_method             = var.cf_ssl_support_method
  }

  depends_on = [aws_acm_certificate_validation.cdn_cert]
}
