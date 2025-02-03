terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# CloudFront requires SSL certificates to be provisioned in the North Virginia (us-east-1) region.
provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}