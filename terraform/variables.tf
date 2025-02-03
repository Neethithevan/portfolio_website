variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-2"
}

variable "env" {
  type        = string
  description = "The environment in which the resources are being created."
  default     = "dev"
}

variable "prefix" {
  type        = string
  description = "The prefix to be added to resource names"
  default     = "www"
}
variable "domain_name" {
  type        = string
  description = "The domain name for the website."
  default     = "neethithevan.com"
}
variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
  default     = "neethithevan.com"
}
variable "common_tags" {
  type        = map(string)
  description = "Common tags you want applied to all components."
}

variable "project_name" {
  type        = string
  description = "The name of the project."
  default     = "static-website"
}