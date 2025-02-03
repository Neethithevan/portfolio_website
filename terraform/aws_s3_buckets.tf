# ========================================================================
# S3 BUCKET FOR STATIC WEBSITE HOSTING
# ========================================================================

# ✅ Create an S3 Bucket for hosting the static website
resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name

  tags = var.common_tags
}

# ✅ Configure S3 Bucket for Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# ✅ Set S3 Bucket Ownership Controls (BucketOwnerPreferred for better IAM control)
resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# ✅ Block All Public Access to the S3 Bucket
resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ========================================================================
# S3 BUCKET POLICY: ALLOW CLOUDFRONT ACCESS ONLY
# ========================================================================

resource "aws_s3_bucket_policy" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid       = "AllowCloudFrontServicePrincipalReadOnly"
      Effect    = "Allow"
      Principal = { Service = "cloudfront.amazonaws.com" }
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.static_website.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.static_site_cdn.arn
        }
      }
    }]
  })
}
