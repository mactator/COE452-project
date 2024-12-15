output "users_table" {
  value = aws_dynamodb_table.users.name
}

output "events_table" {
  value = aws_dynamodb_table.events.name
}

output "rsvps_table" {
  value = aws_dynamodb_table.rsvps.name
}

output "users_table_name" {
  description = "Name of the users DynamoDB table"
  value       = aws_dynamodb_table.users.name
}

output "users_table_arn" {
  description = "ARN of the users DynamoDB table"
  value       = aws_dynamodb_table.users.arn
}
