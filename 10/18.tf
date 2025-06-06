resource "aws_lambda_function" "example" {
  function_name = "secure-function"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  vpc_config {
    subnet_ids         = ["subnet-0abcd1234efgh5678"]
    security_group_ids = ["sg-01234abcd"]
  }
}
