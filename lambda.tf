resource "aws_lambda_function" "main" {
  for_each = local.lambda_functions
  function_name = "${local.resource_prefix}-${each.key}"
  role          = aws_iam_role.lambda_role.arn
  handler       = each.value.handler
  runtime       = "nodejs18.x"
  
  filename         = data.archive_file.lambda_zip[each.key].output_path
  source_code_hash = data.archive_file.lambda_zip[each.key].output_base64sha256
  
  description = each.value.description
  timeout     = 30
  memory_size = 128

  environment {
    variables = each.value.environment
  }

  tags = var.common_tags

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_iam_role_policy_attachment.lambda_dynamodb,
    aws_iam_role_policy_attachment.lambda_s3,
    aws_s3_object.lambda_zip
  ]

  lifecycle {
    ignore_changes = [
      last_modified,
      source_code_hash
    ]
  }
}
