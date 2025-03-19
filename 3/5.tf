#variables.tf
variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = string
}

#main.tf
resource "azurerm_virtual_network" "main" {
  name                = "example-vnet"
  location            = "East US"
  resource_group_name = "example-rg"
  address_space       = [var.vnet_address_space]
}

#terraform.tfvars
vnet_address_space = "10.0.0.0/16"
