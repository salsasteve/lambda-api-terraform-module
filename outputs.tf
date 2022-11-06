# Output value definitions

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.auth_crud.function_name
}

output "state_bucket_name" {
  description = "Name of the S3 bucket used to store Terraform state."
  value = var.state_bucket_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
}

output "dynamodb_arn" {
  description = "ARN of the DynamoDB table."

  value = aws_dynamodb_table.tag.arn
}