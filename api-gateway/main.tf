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
  integration_uri  = aws_lambda_function.create_user.invoke_arn

  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_users_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.get_users.invoke_arn

  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "delete_user_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.delete_user.invoke_arn

  payload_format_version = "2.0"
}

# Permissions for API Gateway to Invoke Lambdas
resource "aws_lambda_permission" "api_gateway_permissions" {
  for_each = {
    create_user = aws_lambda_function.create_user.function_name
    get_users   = aws_lambda_function.get_users.function_name
    delete_user = aws_lambda_function.delete_user.function_name
  }

  statement_id  = "AllowApiGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*"
}
