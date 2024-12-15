# API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = "eventat-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "default"
  auto_deploy = true
}

# API Routes
resource "aws_apigatewayv2_route" "create_user_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /users"
  target    = "integrations/${aws_apigatewayv2_integration.create_user_integration.id}"
}

resource "aws_apigatewayv2_route" "get_users_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /users"
  target    = "integrations/${aws_apigatewayv2_integration.get_users_integration.id}"
}

resource "aws_apigatewayv2_route" "delete_user_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "DELETE /users/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_user_integration.id}"
}

# API Integrations
resource "aws_apigatewayv2_integration" "create_user_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.create_user_lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_users_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.get_users_lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "delete_user_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.delete_user_lambda_arn
  payload_format_version = "2.0"
}

# Permissions
resource "aws_lambda_permission" "api_gateway_permissions" {
  for_each = var.lambda_function_names

  statement_id  = "AllowApiGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*"
}
