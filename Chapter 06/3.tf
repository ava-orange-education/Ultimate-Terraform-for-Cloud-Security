resource "azurerm_network_security_group" "my_nsg" {
  name                = "myNSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.my_rg.name

  security_rule {
    name                       = "Allow_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = ["192.168.1.0/24"]  # Restrict access to a trusted IP range
    destination_address_prefix = "*"
  }
}
