resource "aws_vpc_endpoint" "example" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.vpce.us-east-1.lambda"
}
