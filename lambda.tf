resource "aws_lambda_function" "auth_crud" {
  function_name = "${var.lambda_key}-${random_string.suffix.result}"

  s3_bucket = var.state_bucket_name
  s3_key    = "${var.lambda_key}.zip"

  runtime = "python3.8"
  handler = "auth_crud.lambda_handler"

  source_code_hash = data.archive_file.auth_crud_lambda_zip.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  tags = {
	environment = var.environment
  }
  environment {
    variables = {
      DYNAMODB_TABLE = var.tag_table_name
    }
  }
}

resource "aws_cloudwatch_log_group" "auth_crud_log_group" {
  name = "/aws/lambda/${aws_lambda_function.auth_crud.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name    
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_dynamic_policy_document" {
  statement {
    sid       = "DynamoDBAccess"
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["arn:aws:dynamodb:*"]
  }
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "serverless_lambda_policy"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}
  
resource "aws_iam_policy" "lambda_policy" {
  name        = "serverless_lambda_policy"
  description = "Policy for serverless lambda"
  policy      = data.aws_iam_policy_document.lambda_dynamic_policy_document.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}
