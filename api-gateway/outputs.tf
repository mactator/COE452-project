output "http_api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

output "create_user_route_key" {
  value = aws_apigatewayv2_route.create_user_route.route_key
}
