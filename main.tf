# Include modules
module "vpc" {
  source  = "./vpc"
}

module "dynamodb" {
  source = "./dynamodb"
}

# module "lambda" {
#   source = "./lambda"
# }

# module "api_gateway" {
#   source = "./api-gateway"

  
# }

module "lambda" {
  source = "./lambda"

  users_table_name = module.dynamodb.users_table_name
  users_table_arn  = module.dynamodb.users_table_arn
  events_table_arn = module.dynamodb.events_table_arn
  rsvps_table_arn  = module.dynamodb.rsvps_table_arn
  JWT_SECRET_KEY  = var.JWT_SECRET_KEY
}



module "api_gateway" {
  source = "./api-gateway"

  create_user_lambda_arn = module.lambda.create_user_lambda_arn
  get_users_lambda_arn   = module.lambda.get_users_lambda_arn
  delete_user_lambda_arn = module.lambda.delete_user_lambda_arn
  lambda_function_names  = module.lambda.lambda_function_names
}

