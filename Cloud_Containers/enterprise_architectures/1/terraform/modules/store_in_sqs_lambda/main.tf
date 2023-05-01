variable "function_name" {}

resource "aws_lambda_function" "store_in_sqs" {
  function_name = var.function_name
  handler       = "handler.store_in_sqs"
  runtime       = "python3.8"
  timeout       = 60

  role = aws_iam_role.lambda.arn

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.queue.url
    }
  }

  filename = "lambda_functions/store_in_sqs.zip"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role" "lambda" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

resource "aws_sqs_queue" "queue" {
  name = "incoming_requests"
}