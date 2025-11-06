resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_virtual_machine" "compliant_vm" {
  name                  = "example-vm"
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  vm_size               = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.example.id]
  # Image and OS configuration details omitted for brevity

  tags = {
    Compliance = "CIS_NIST"
  }
}

resource "azurerm_policy_assignment" "deny_public_ip" {
  name                 = "deny-public-ip-vms"
  policy_definition_id = azurerm_policy_definition.deny_public_ip.id  # Assume this definition enforces no public IPs on VMs
  scope                = azurerm_resource_group.example.id
}
