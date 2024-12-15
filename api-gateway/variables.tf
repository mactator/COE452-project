variable "create_user_lambda_arn" {
  description = "ARN of the create_user Lambda function"
}

variable "get_users_lambda_arn" {
  description = "ARN of the get_users Lambda function"
}

variable "delete_user_lambda_arn" {
  description = "ARN of the delete_user Lambda function"
}

variable "lambda_function_names" {
  description = "Names of all Lambda functions"
  type        = map(string)
}
