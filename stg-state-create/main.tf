################################
# local variables
################################

locals {
  project_name = "${var.team}-${var.project}-${var.environment}-${random_string.suffix.result}"
}

################################
# Variables
################################

variable "environment" {
  type        = string
  description = "AWS environment"
  default = "stg"
}

variable "project" {
  type        = string
  description = "Project name that deployed by Terraform."
  default = "auth-crud-state"
}

variable "team" {
  type        = string
  description = "Team that deployed under Terraform."
  default = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default = "us-east-1"
}

#########################################
# S3 bucket for Terraform state storage
#########################################
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = local.project_name
}

resource "aws_s3_bucket_acl" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  acl    = "private" 
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  rule {
	apply_server_side_encryption_by_default {
	  sse_algorithm = "AES256"
	}
  }
}

resource "aws_s3_bucket_versioning" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
	status = "Enabled"
  }
}

#########################################
# DynamoDB table for Terraform state lock
#########################################

resource "aws_dynamodb_table" "state_lock" {
  name = local.project_name
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"
  attribute {
	name = "LockID"
	type = "S"
  }
}