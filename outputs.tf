output "api_endpoint" {
  value = module.api_gateway.http_api_endpoint
}

output "create_user_route" {
  value = module.api_gateway.create_user_route_key
}
