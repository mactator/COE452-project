output "lambda_exec_role" {
  value = aws_iam_role.lambda_exec.arn
}

output "create_user_lambda_arn" {
  description = "ARN of the create_user Lambda function"
  value       = aws_lambda_function.create_user.invoke_arn
}

output "get_users_lambda_arn" {
  description = "ARN of the get_users Lambda function"
  value       = aws_lambda_function.get_users.invoke_arn
}

output "delete_user_lambda_arn" {
  description = "ARN of the delete_user Lambda function"
  value       = aws_lambda_function.delete_user.invoke_arn
}

output "lambda_function_names" {
  description = "Names of all Lambda functions"
  value = {
    create_user = aws_lambda_function.create_user.function_name
    get_users   = aws_lambda_function.get_users.function_name
    delete_user = aws_lambda_function.delete_user.function_name
  }
}
