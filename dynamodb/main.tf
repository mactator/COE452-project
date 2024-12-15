resource "aws_dynamodb_table" "users" {
  name         = "eventat-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "role"
    type = "S"
  }

  global_secondary_index {
    name            = "email-index"
    hash_key        = "email"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "username-index"
    hash_key        = "username"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "role-index"
    hash_key        = "role"
    projection_type = "ALL"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "events" {
  name         = "eventat-events"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }

  attribute {
    name = "date_range"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  attribute {
    name = "createdBy"
    type = "S"
  }

  attribute {
    name = "location"
    type = "S"
  }

  attribute {
    name = "max_attendee"
    type = "N"
  }

  global_secondary_index {
    name            = "title-index"
    hash_key        = "title"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "category-index"
    hash_key        = "category"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "createdBy-index"
    hash_key        = "createdBy"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "date_range-index"
    hash_key        = "date_range"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "location-index"
    hash_key        = "location"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "max_attendee-index"
    hash_key        = "max_attendee"
    projection_type = "ALL"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_dynamodb_table" "rsvps" {
  name         = "eventat-rsvps"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "event_id"
  range_key    = "user_id"

  attribute {
    name = "event_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "response"
    type = "S"
  }

  global_secondary_index {
    name            = "response-index"
    hash_key        = "response"
    projection_type = "ALL"
  }

  tags = {
    Environment = "dev"
  }
}
