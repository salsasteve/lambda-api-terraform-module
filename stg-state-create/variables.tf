variable "aws_region" {
  description = "AWS region for all resources."
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
