terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

locals {
  project_name = "${var.team}-${var.project}-${var.environment}-${random_string.suffix.result}"
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

data "archive_file" "auth_crud_lambda_zip" {
  type = "zip"

  source_dir  = "${path.module}/${var.lambda_key}"
  output_path = "${path.module}/${var.lambda_key}.zip"
}

resource "aws_s3_object" "auth_crud_lambda_upload" {
  bucket = var.state_bucket_name

  key    = "${var.lambda_key}.zip"
  source = data.archive_file.auth_crud_lambda_zip.output_path

  etag = filemd5(data.archive_file.auth_crud_lambda_zip.output_path)
}
