# Lambda IAM Role
resource "aws_iam_role" "lambda_exec" {
  name = "eventat-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach Basic Lambda Execution Policy
resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "attach-lambda-basic"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Functions
resource "aws_lambda_function" "create_user" {
  function_name = "eventat-create-user"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "createUser.handler"
  runtime       = "nodejs18.x"

  filename         = "createUser.zip"
  source_code_hash = filebase64sha256("createUser.zip")

  environment {
    variables = {
      USERS_TABLE = aws_dynamodb_table.users.name
    }
  }
}

resource "aws_lambda_function" "get_users" {
  function_name = "eventat-get-users"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "getUsers.handler"
  runtime       = "nodejs18.x"

  filename         = "getUsers.zip"
  source_code_hash = filebase64sha256("getUsers.zip")

  environment {
    variables = {
      USERS_TABLE = aws_dynamodb_table.users.name
    }
  }
}

resource "aws_lambda_function" "delete_user" {
  function_name = "eventat-delete-user"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "deleteUser.handler"
  runtime       = "nodejs18.x"

  filename         = "deleteUser.zip"
  source_code_hash = filebase64sha256("deleteUser.zip")

  environment {
    variables = {
      USERS_TABLE = aws_dynamodb_table.users.name
    }
  }
}

# Additional IAM Policy for DynamoDB Access
resource "aws_iam_policy" "lambda_dynamodb_access" {
  name = "lambda-dynamodb-access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ],
        Resource = [
          aws_dynamodb_table.users.arn,
          aws_dynamodb_table.events.arn,
          aws_dynamodb_table.rsvps.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_dynamodb_attach" {
  name       = "attach-lambda-dynamodb-policy"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.lambda_dynamodb_access.arn
}
