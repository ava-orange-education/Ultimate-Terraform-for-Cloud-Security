# Define the Customer Gateway (CGW)
resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = "203.0.113.12"  # On-premises VPN device public IP
  type       = "ipsec.1"
}

# Create the VPN connection
resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"

  tunnel1_inside_cidr = "169.254.10.0/30"
  tunnel2_inside_cidr = "169.254.11.0/30"
}
