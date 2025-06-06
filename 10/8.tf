resource "aws_security_group" "example" {
  name        = "example-sg-${var.environment}"
  description = "Security group for ${var.environment} environment"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.environment == "prod" ? ["203.0.113.0/24"] : ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.environment == "prod" ? ["203.0.113.0/24"] : ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}
