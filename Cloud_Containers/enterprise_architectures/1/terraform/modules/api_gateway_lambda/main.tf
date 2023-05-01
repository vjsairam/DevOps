variable "function_name" {}
variable "region" {}

resource "aws_apigateway_rest_api" "api" {
  name = "api-gateway"
}

resource "aws_apigateway_resource" "proxy" {
  rest_api_id = aws_apigateway_rest_api.api.id
  parent_id   = aws_apigateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_lambda_function" "analyze_request" {
  function_name = var.function_name
  handler       = "handler.analyze_request"
  runtime       = "python3.8"
  timeout       = 60

  role = aws_iam_role.lambda.arn

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.queue.url
    }
  }

  filename = "lambda_functions/analyze_request.zip"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.analyze_request.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_apigateway_rest_api.api.id}/*/*"
}

resource "aws_sqs_queue" "queue" {
  name = "incoming_requests"
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