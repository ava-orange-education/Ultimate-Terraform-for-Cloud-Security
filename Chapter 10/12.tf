# Provision an Azure VPN Gateway
resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "example-vpn-gateway"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"

  ip_configurations {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_public_ip.id
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

# Create a Local Network Gateway representing on-premises device
resource "azurerm_local_network_gateway" "local_gateway" {
  name                = "example-local-gateway"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  gateway_address     = "203.0.113.1"  # On-premises public IP
  address_space       = ["192.168.1.0/24"]
}

# Establish the VPN Connection
resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                         = "example-vpn-connection"
  location                     = azurerm_resource_group.example.location
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_gateway_id   = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id     = azurerm_local_network_gateway.local_gateway.id
  connection_type              = "IPsec"
  routing_weight               = 10
  shared_key                   = "YourSharedKey123!"  # Pre-shared key for IPsec connection
}
