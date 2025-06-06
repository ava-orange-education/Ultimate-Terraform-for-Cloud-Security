variable "simulate_failure" {
  description = "Toggle to simulate an outage"
  default     = false
}

resource "aws_instance" "web" {
  count         = var.simulate_failure ? 0 : 1
  ami           = "ami-123456"
  instance_type = "t3.medium"

  tags = {
    Name = "WebServer"
  }
}
