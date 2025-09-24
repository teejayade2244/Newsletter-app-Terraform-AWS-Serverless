output "api_url" {
  value = aws_apigatewayv2_stage.main.invoke_url
}

output "lambda_functions" {
  value = { for k, v in aws_lambda_function.main : k => v.function_name }
}
