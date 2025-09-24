resource "aws_dynamodb_table" "users_table" {
  name         = "${local.resource_prefix}-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  tags = var.common_tags
}

resource "aws_dynamodb_table" "newsletters_table" {
  name         = "${local.resource_prefix}-newsletters"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.common_tags
}
