# ========================================================================
# ✅ CREATE AN ACM SSL CERTIFICATE WITH DNS VALIDATION
# ========================================================================
resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name          # Domain name with www. prefix
  # subject_alternative_names = ["www.${var.domain_name}", "*.${var.domain_name}"] # Supports wildcard subdomains
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"                    # Using DNS validation instead of email

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true # Ensures a new certificate is validated before replacing the old one
  }
}

# ========================================================================
# ✅ CREATE ROUTE 53 RECORDS FOR SSL CERTIFICATE VALIDATION
# ========================================================================
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = aws_route53_zone.primary_zone.zone_id
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
}

# ========================================================================
# ✅ VALIDATE ACM CERTIFICATE AFTER DNS RECORD CREATION
# ========================================================================
resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
