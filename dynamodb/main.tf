# DynamoDB Tables for Users, Events, and RSVPs

resource "aws_dynamodb_table" "users" {
  name           = "eventat-users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  global_secondary_index {
    name            = "email-index"
    hash_key        = "email"
    projection_type = "ALL"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "events" {
  name           = "eventat-events"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "rsvps" {
  name           = "eventat-rsvps"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "event_id"
  range_key      = "user_id"

  attribute {
    name = "event_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Environment = "dev"
  }
}
