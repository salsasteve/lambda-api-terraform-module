# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket used to store Terraform state."
  type    = string
}

variable "team" {
  description = "Name of the team that owns this infrastructure."
  type    = string
}

variable "environment" {
  description = "Environment for all resources."
  type    = string
}

variable "project" {
  description = "Name of the project that owns this infrastructure."
  type    = string
}

variable "lambda_key" {
  description = "Key of the Lambda function to deploy."
  type    = string
}

variable "tag_table_name" {
  description = "Name of the DynamoDB table that stores tags."
  type    = string
}
