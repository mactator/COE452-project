# Include modules
module "vpc" {
  source  = "./vpc"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "lambda" {
  source = "./lambda"
}

module "api_gateway" {
  source = "./api_gateway"
}
