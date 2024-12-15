output "users_table_name" {
  value = aws_dynamodb_table.users.name
}

output "users_table_arn" {
  value = aws_dynamodb_table.users.arn
}

output "events_table_name" {
  value = aws_dynamodb_table.events.name
}

output "events_table_arn" {
  value = aws_dynamodb_table.events.arn
}

output "rsvps_table_name" {
  value = aws_dynamodb_table.rsvps.name
}

output "rsvps_table_arn" {
  value = aws_dynamodb_table.rsvps.arn
}
