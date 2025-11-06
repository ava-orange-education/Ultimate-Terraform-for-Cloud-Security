# AWS
resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = "vpc-0abcd1234efgh5678"
  vpc_id      = aws_vpc.main.id
  peer_region = "us-west-2"
  auto_accept = true
}

# Azure
resource "azurerm_virtual_network_peering" "peer" {
  name                         = "vnet-peer"
  resource_group_name          = azurerm_resource_group.main.name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = azurerm_virtual_network.remote.id
}

# GCP
resource "google_compute_network_peering" "peer" {
  name         = "peering-connection"
  network      = google_compute_network.main.self_link
  peer_network = google_compute_network.remote.self_link
}
