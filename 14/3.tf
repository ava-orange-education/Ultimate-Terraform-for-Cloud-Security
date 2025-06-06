variable "location" {
  type        = string
  description = "Azure region to deploy the network"
  default     = "eastus"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR block for the virtual network"
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  type        = number
  description = "Number of equal‑sized subnets to create"
  default     = 3
}

locals {
  # Generate a list of subnet CIDRs by splitting the VNet CIDR
  subnet_cidrs = [
    for idx in range(var.subnet_count) :
    cidrsubnet(var.vnet_cidr, 8, idx)
  ]
  
  # Create human‑readable subnet names
  subnet_names = [
    for idx, cidr in local.subnet_cidrs :
    join("-", ["subnet", format("%02d", idx + 1)])
  ]
}

resource "azurerm_virtual_network" "vnet" {
  name                = "templated-vnet"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Dynamically create one subnet per CIDR in local.subnet_cidrs
resource "azurerm_subnet" "subnets" {
  for_each           = zipmap(local.subnet_names, local.subnet_cidrs)
  name               = each.key
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes   = [each.value]
}
