variable "cf_origin_http_port" {
  default = 80
  type    = number
}

variable "cf_origin_https_port" {
  default = 443
  type    = number
}

variable "cf_origin_ssl_protocols" {
  type    = list(string)
  default = ["TLSv1", "TLSv1.1", "TLSv1.2"]
}

variable "cf_origin_protocol_policy" {
  default = "https-only"
}

variable "cf_origin_keepalive_timeout" {
  default = 60
  type    = number
}

variable "cf_enabled" {
  default = true
}

variable "cf_is_ipv6_enabled" {
  default = true
}

variable "cf_default_root_object" {
  default = "index.html"
}

variable "cf_default_cache_behavior_allowed_methods" {
  type    = list(string)
  default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cf_default_cache_behavior_cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "cf_default_cache_behavior_forwarded_values_query_string" {
  default = false
}

variable "cf_default_cache_behavior_forwarded_values_headsers" {
  type    = list(string)
  default = ["Origin"]
}

variable "cf_default_cache_behavior_forwarded_values_cookies_forward" {
  default = "none"
  type    = string
}

variable "cf_default_cache_behavior_min_ttl" {
  default = 0
  type    = number
}

variable "cf_default_cache_behavior_default_ttl" {
  default = 86400
  type    = number
}

variable "cf_default_cache_behavior_max_ttl" {
  default = 31536000
  type    = number
}

variable "cf_default_cache_behavior_compress" {
  default = true
  type    = bool
}

variable "cf_default_cache_behavior_viewer_protocol_policy" {
  default = "redirect-to-https"
  type    = string
}

variable "cf_price_class" {
  default = "PriceClass_200"
  type    = string
}

variable "cf_geo_restriction" {
  default = "none"
  type    = string
}

variable "cf_geo_restriction_locations" {
  type    = list(string)
  default = []
}

variable "cf_default_certificate" {
  default = false
  type    = bool
}

variable "cf_ssl_support_method" {
  default = "sni-only"
  type    = string
}