#Security center
resource "azurerm_security_center_subscription_pricing" "example" {
  tier = "Standard"
}

resource "azurerm_security_center_workspace" "example" {
  name                = "example-security-center"
  location            = "East US"
  resource_group_name = "example-resource-group"
}

# NSG
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = "East US"
  resource_group_name = "example-resource-group"

  security_rule {
    name                       = "Allow-SSH"
    priority                  = 100
    direction                 = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "22"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }
}

#Key vault
resource "azurerm_key_vault" "example" {
  name                = "example-keyvault"
  location            = "East US"
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "standard"
  
  access_policy {
    tenant_id = "<tenant_id>"
    object_id = "<object_id>"

    key_permissions = [
      "get",
      "list",
      "create",
      "delete"
    ]

    secret_permissions = [
      "get",
      "list"
    ]
  }
}
