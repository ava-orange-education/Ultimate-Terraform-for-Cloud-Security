resource "aws_network_acl" "example_nacl" {
  vpc_id = var.vpc_id

  # Allow inbound HTTP traffic from a trusted range
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "203.0.113.0/24"
    from_port  = 80
    to_port    = 80
  }

  # Allow inbound HTTPS traffic from a trusted range
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "203.0.113.0/24"
    from_port  = 443
    to_port    = 443
  }

  # Deny all other inbound traffic
  ingress {
    protocol   = "-1"
    rule_no    = 120
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
