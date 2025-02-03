# ========================================================================
# ✅ OUTPUT: List of Deployed Files in Distribution Directory
# ========================================================================
output "deployed_files" {
  description = "List of all files in the distribution directory"
  value       = fileset(local.dist_dir, "**/*")
}

# ========================================================================
# ✅ OUTPUT: S3 Website Endpoint (Only If Using S3 Website Hosting)
# ========================================================================
output "s3_website_endpoint" {
  description = "S3 Static Website Hosting URL (HTTP)"
  value       = aws_s3_bucket_website_configuration.website_bucket.website_endpoint
}

# ========================================================================
# ✅ OUTPUT: CloudFront Distribution ID
# ========================================================================
output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.static_site_cdn.id
}

# ========================================================================
# ✅ OUTPUT: CloudFront Distribution URL (Primary HTTPS Access)
# ========================================================================
output "cloudfront_url" {
  description = "CloudFront Distribution URL (HTTPS)"
  value       = "https://${aws_cloudfront_distribution.static_site_cdn.domain_name}"
}

# ========================================================================
# ✅ OUTPUT: Custom Domain Website URL (Final Hosted Website)
# ========================================================================
output "website_url" {
  description = "Final Website URL with Custom Domain (HTTPS)"
  value       = "https://${var.domain_name}"
}
