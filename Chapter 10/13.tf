# Provision a VPN Gateway in a specific region
resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "example-vpn-gateway"
  network = google_compute_network.example_network.name
  region  = "us-central1"
}

# Create a VPN Tunnel to connect to the on-premises network
resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name                   = "example-vpn-tunnel"
  vpn_gateway            = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip                = "203.0.113.12"      # On-premises VPN device public IP
  shared_secret          = "your-shared-secret"
  ike_version            = 2
  local_traffic_selector = ["10.0.0.0/16"]
  remote_traffic_selector = ["192.168.1.0/24"]
}
