locals {
  vm_size = terraform.workspace == "prod" ? "Standard_D4s_v3" : 
            terraform.workspace == "staging" ? "Standard_D2s_v3" : 
            "Standard_B1s"
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = local.vm_size
  admin_username      = "azureuser"
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  network_interface_ids = [azurerm_network_interface.example.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
