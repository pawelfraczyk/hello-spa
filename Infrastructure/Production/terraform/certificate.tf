################################################################################
# Main cert
# - if CDN cert then it must be located in us-east-1 region
resource "aws_acm_certificate" "cdn_cert" {
  provider = aws.us-east-1

  domain_name = var.domain
  subject_alternative_names = [
    "*.${var.domain}"
  ]
  validation_method = "DNS"

  tags = {
    Name        = var.domain
    Project     = var.project
    Environment = var.stage
    Terraform   = true
  }

  lifecycle {
    create_before_destroy = false
  }
}


resource "aws_route53_record" "cdn_cert_validation" {
  provider = aws.us-east-1
  name     = aws_acm_certificate.cdn_cert.domain_validation_options.0.resource_record_name
  type     = aws_acm_certificate.cdn_cert.domain_validation_options.0.resource_record_type
  zone_id  = data.aws_route53_zone.main.zone_id
  records  = [aws_acm_certificate.cdn_cert.domain_validation_options.0.resource_record_value]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "cdn_cert" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cdn_cert.arn
  validation_record_fqdns = [aws_route53_record.cdn_cert_validation.fqdn]

  depends_on = [aws_acm_certificate.cdn_cert, aws_route53_record.cdn_cert_validation]
}
