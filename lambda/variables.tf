variable "users_table_name" {
  description = "Name of the Users DynamoDB table"
  type        = string
}

variable "users_table_arn" {
  description = "ARN of the Users DynamoDB table"
  type        = string
}

variable "events_table_arn" {
  description = "ARN of the Events DynamoDB table"
  type        = string
}

variable "rsvps_table_arn" {
  description = "ARN of the RSVPs DynamoDB table"
  type        = string
}
