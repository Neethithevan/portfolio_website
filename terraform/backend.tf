# # ========================================================================
# # ✅ CHECK IF THE S3 BUCKET EXISTS
# # ========================================================================
# data "aws_s3_bucket" "existing_tf_bucket" {
#   bucket = "14728-terraform-state-backend-us-west-2-dev"
# }

# # Create S3 bucket only if it does not exist
# resource "aws_s3_bucket" "tf_bucket" {
#   count  = length(data.aws_s3_bucket.existing_tf_bucket.id) > 0 ? 0 : 1
#   bucket = "14728-terraform-state-backend-us-west-2-dev"

#   tags = {
#     Name = "S3 Remote Terraform State Store"
#   }
# }

# # ========================================================================
# # ✅ CHECK IF DYNAMODB TABLE EXISTS
# # ========================================================================
# data "aws_dynamodb_table" "existing_tf_lock" {
#   name = "14728-terraform-state-us-west-2-dev"
# }

# # Create DynamoDB Table for state locking only if it does not exist
# resource "aws_dynamodb_table" "terraform_lock" {
#   count          = length(data.aws_dynamodb_table.existing_tf_lock.id) > 0 ? 0 : 1
#   name           = "14728-terraform-state-us-west-2-dev"
#   read_capacity  = 5
#   write_capacity = 5
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "DynamoDB Terraform State Lock Table"
#   }
# }

# # ========================================================================
# # ✅ CONFIGURE REMOTE BACKEND FOR TERRAFORM
# # ========================================================================
# # For local usage
# # terraform init \
# #   -backend-config="bucket=14728-terraform-state-backend-us-west-2-dev" \
# #   -backend-config="dynamodb_table=14728-terraform-state-us-west-2-dev" \
# #   -backend-config="key=static-website.tfstate" \
# #   -backend-config="region=us-west-2"


# terraform {
#   backend "s3" {
#     encrypt        = true
#     bucket         = "14728-terraform-state-backend-us-west-2-dev"
#     dynamodb_table = "14728-terraform-state-us-west-2-dev"
#     key            = "static-website.tfstate"
#     region         = "us-west-2"
#   }
# }

