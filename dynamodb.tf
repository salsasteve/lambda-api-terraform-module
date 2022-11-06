resource "aws_dynamodb_table" "tag" {
  name = var.tag_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "uid"
  attribute {
	name = "uid"
	type = "S"
  }
  tags = {
	environment = var.environment
  }
}