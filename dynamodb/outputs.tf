output "users_table" {
  value = aws_dynamodb_table.users.name
}

output "events_table" {
  value = aws_dynamodb_table.events.name
}

output "rsvps_table" {
  value = aws_dynamodb_table.rsvps.name
}
