resource "aws_apigatewayv2_api" "main" {
  name          = local.resource_prefix
  protocol_type = "HTTP"
  tags          = var.common_tags
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id           = aws_apigatewayv2_api.main.id
  name             = "${local.resource_prefix}-jwt-authorizer"
  authorizer_type  = "REQUEST"
  authorizer_uri   = aws_lambda_function.main["authorizer"].invoke_arn
  identity_sources = ["$request.header.Authorization"]
}

resource "aws_apigatewayv2_integration" "lambda" {
  for_each = { for k, v in local.lambda_functions : k => v if k != "authorizer" }

  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.main[each.key].invoke_arn
}

resource "aws_apigatewayv2_route" "auth" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /auth/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda["auth"].id}"
}

resource "aws_apigatewayv2_route" "newsletters" {
  for_each = {
    get  = "GET /newsletters"
    post = "POST /newsletters"
  }

  api_id         = aws_apigatewayv2_api.main.id
  route_key      = each.value
  target         = "integrations/${aws_apigatewayv2_integration.lambda["newsletter"].id}"
  authorizer_id  = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.stage
  auto_deploy = true
  tags        = var.common_tags
}

resource "aws_lambda_permission" "api_gateway" {
  for_each = aws_lambda_function.main

  statement_id  = "AllowExecutionFromAPIGateway-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
