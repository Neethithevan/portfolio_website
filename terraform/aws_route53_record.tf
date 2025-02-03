# ========================================================================
# ✅ CREATE A ROUTE 53 HOSTED ZONE FOR THE DOMAIN
# ========================================================================

resource "aws_route53_zone" "primary_zone" {
  name = var.domain_name

  tags = var.common_tags
}


# ========================================================================
# ✅ CREATE A DNS RECORD FOR THE ROOT DOMAIN (example.com → CloudFront)
# ========================================================================

resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.static_site_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# ========================================================================
# ✅ CREATE A DNS RECORD FOR THE WWW SUBDOMAIN (www.example.com → CloudFront)
# ========================================================================

resource "aws_route53_record" "www_subdomain" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"


  alias {
    name                   = aws_cloudfront_distribution.static_site_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.static_site_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
