# Resource Group
resource "azurerm_resource_group" "ha_rg" {
  name     = "ha-rg"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "ha_vnet" {
  name                = "ha-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ha_rg.location
  resource_group_name = azurerm_resource_group.ha_rg.name
}

# Public Subnet (for Load Balancer)
resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.ha_rg.name
  virtual_network_name = azurerm_virtual_network.ha_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Private Subnet (for VMs)
resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.ha_rg.name
  virtual_network_name = azurerm_virtual_network.ha_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "ha_public_ip" {
  name                = "ha-public-ip"
  location            = azurerm_resource_group.ha_rg.location
  resource_group_name = azurerm_resource_group.ha_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure Load Balancer
resource "azurerm_lb" "ha_lb" {
  name                = "ha-lb"
  location            = azurerm_resource_group.ha_rg.location
  resource_group_name = azurerm_resource_group.ha_rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend"
    public_ip_address_id = azurerm_public_ip.ha_public_ip.id
  }
}

# Backend Address Pool for Load Balancer
resource "azurerm_lb_backend_address_pool" "ha_backend_pool" {
  name                = "ha-backend-pool"
  resource_group_name = azurerm_resource_group.ha_rg.name
  loadbalancer_id     = azurerm_lb.ha_lb.id
}

# Network Interface for VM in Private Subnet (AZ1)
resource "azurerm_network_interface" "vm_nic1" {
  name                = "vm-nic-1"
  location            = azurerm_resource_group.ha_rg.location
  resource_group_name = azurerm_resource_group.ha_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.ha_backend_pool.id]
  }
}

# Network Interface for VM in Private Subnet (AZ2)
resource "azurerm_network_interface" "vm_nic2" {
  name                = "vm-nic-2"
  location            = azurerm_resource_group.ha_rg.location
  resource_group_name = azurerm_resource_group.ha_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.ha_backend_pool.id]
  }
}

# Linux Virtual Machine in AZ1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "ha-vm-1"
  resource_group_name = azurerm_resource_group.ha_rg.name
  location            = azurerm_resource_group.ha_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.vm_nic1.id]
  admin_password      = "Password1234!"  # Replace with secure credentials in production

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Linux Virtual Machine in AZ2
resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "ha-vm-2"
  resource_group_name = azurerm_resource_group.ha_rg.name
  location            = azurerm_resource_group.ha_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.vm_nic2.id]
  admin_password      = "Password1234!"  # Replace with secure credentials in production

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
