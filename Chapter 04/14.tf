resource "aws_vpn_gateway" "example" {
  vpc_id = "vpc-12345678"
  amazon_side_asn = "65000"
}

resource "aws_vpn_connection" "to_azure" {
  customer_gateway_id = "cgw-12345678"
  type = "ipsec.1"
  static_routes_only = false
  
  tunnel1_preshared_key = "example-key-123"
  tunnel1_inside_cidr = "169.254.10.0/30"
  tunnel2_preshared_key = "example-key-456"
  tunnel2_inside_cidr = "169.254.11.0/30"
}
