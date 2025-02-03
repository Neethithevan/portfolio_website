# ========================================================================
# ✅ CREATE CLOUDFRONT ORIGIN ACCESS CONTROL (OAC) FOR SECURE S3 ACCESS
# ========================================================================
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "OAC-${aws_s3_bucket.static_website.bucket}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ========================================================================
# ✅ CREATE CLOUDFRONT DISTRIBUTION FOR STATIC WEBSITE
# ========================================================================
resource "aws_cloudfront_distribution" "static_site_cdn" {
  depends_on = [aws_s3_bucket.static_website]

  origin {
    domain_name              = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id                = "${var.bucket_name}-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  comment             = "${var.domain_name} CloudFront Distribution"
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  price_class         = "PriceClass_100" # Restrict to North America and Europe
  wait_for_deployment = true

  aliases = [
    var.domain_name,
    "www.${var.domain_name}"
  ]

  default_root_object = "index.html"

  # ========================================================================
  # ✅ FIXED DEFAULT CACHE BEHAVIOR (ADDED FORWARDED_VALUES)
  # ========================================================================
  default_cache_behavior {
    target_origin_id       = "${var.bucket_name}-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    # ✅ REQUIRED: Fix for "The parameter ForwardedValues is required"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.www_redirect.arn
    }
  }

  # ========================================================================
  # ✅ NO GEO RESTRICTION (ACCESSIBLE GLOBALLY)
  # ========================================================================
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  # ========================================================================
  # ✅ SSL CONFIGURATION (ENFORCING HTTPS WITH ACM CERTIFICATE)
  # ========================================================================
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# ========================================================================
# ✅ CLOUDFRONT FUNCTION FOR WWW TO NON-WWW REDIRECT
# ========================================================================
resource "aws_cloudfront_function" "www_redirect" {
  name    = "www-redirect"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = <<EOT
  function handler(event) {
      var request = event.request;
      var host = request.headers.host.value;

      if (host.startsWith("www.")) {
          var redirectResponse = {
              statusCode: 301,
              statusDescription: "Moved Permanently",
              headers: {
                  location: { value: "https://" + host.substring(4) + request.uri }
              }
          };
          return redirectResponse;
      }
      return request;
  }
  EOT
}