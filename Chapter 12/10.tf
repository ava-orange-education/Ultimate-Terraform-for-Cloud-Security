# Enable AWS Security Hub
resource "aws_securityhub_account" "example" {}

# Create an SNS Topic to receive alerts (optional step)
resource "aws_sns_topic" "scc_alerts" {
  name = "scc-alerts-sns"
}

# Create an API Gateway to receive GCP push notifications
resource "aws_api_gateway_rest_api" "scc_api" {
  name = "scc-alert-api"
}

resource "aws_api_gateway_resource" "scc_resource" {
  rest_api_id = aws_api_gateway_rest_api.scc_api.id
  parent_id   = aws_api_gateway_rest_api.scc_api.root_resource_id
  path_part   = "scc-alerts"
}

resource "aws_api_gateway_method" "scc_post" {
  rest_api_id   = aws_api_gateway_rest_api.scc_api.id
  resource_id   = aws_api_gateway_resource.scc_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Lambda function to process SCC alerts and forward to Security Hub
resource "aws_lambda_function" "scc_to_sh" {
  function_name = "scc-to-securityhub"
  filename      = "lambda.zip"  # Your packaged Lambda code
  handler       = "index.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec.arn
}

# API Gateway integration with Lambda
resource "aws_api_gateway_integration" "scc_integration" {
  rest_api_id             = aws_api_gateway_rest_api.scc_api.id
  resource_id             = aws_api_gateway_resource.scc_resource.id
  http_method             = aws_api_gateway_method.scc_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.scc_to_sh.invoke_arn
}

# Permission for API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scc_to_sh.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.scc_api.execution_arn}/*/*"
}
