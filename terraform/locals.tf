# ========================================================================
# ✅ LOCALS: MODULE CONFIGURATION & DYNAMIC VARIABLES
# ========================================================================
locals {
  dist_dir    = "${path.module}/dist"
  module_name = basename(abspath(path.module))
  prefix      = var.prefix
  env         = var.env
  project     = var.project_name

  # ✅ Get AWS Account ID & Region Dynamically
  aws_account_id = substr(data.aws_caller_identity.current.account_id, 0, 5) 
  aws_region     = data.aws_region.current.name


  # ✅ Content Type Mapping for Common Static Files
  content_types = {
    ".html"  = "text/html",
    ".css"   = "text/css",
    ".js"    = "application/javascript",
    ".json"  = "application/json",
    ".xml"   = "application/xml",
    ".jpg"   = "image/jpeg",
    ".jpeg"  = "image/jpeg",
    ".png"   = "image/png",
    ".gif"   = "image/gif",
    ".svg"   = "image/svg+xml",
    ".webp"  = "image/webp",
    ".ico"   = "image/x-icon",
    ".woff"  = "font/woff",
    ".woff2" = "font/woff2",
    ".ttf"   = "font/ttf",
    ".eot"   = "application/vnd.ms-fontobject",
    ".otf"   = "font/otf"
  }
}

# ========================================================================
# ✅ DATA SOURCES TO FETCH AWS ACCOUNT ID & REGION
# ========================================================================
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
