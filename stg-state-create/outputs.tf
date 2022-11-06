output "dynamodb_arn" {
  description = "ARN of the DynamoDB table."
  value = aws_dynamodb_table.state_lock.arn
}

output "environment" {
  description = "Environment for all resources."
  value = var.environment
}

output "team" {
  description = "Name of the team that owns this infrastructure."
  value = var.team
}

output "project" {
  description = "Name of the project that owns this infrastructure."
  value = var.project
}