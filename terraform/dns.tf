/*
  Domain: Don't forget to provide domain in variables.tf
  Registrar: If any external Registrar - please fill
  Hosted on: 
  Zone created manually
*/
data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "cdn_app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = data.aws_route53_zone.main.name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.default_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.default_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}