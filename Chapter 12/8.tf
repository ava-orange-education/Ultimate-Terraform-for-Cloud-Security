# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

# Enable Azure Defender for a resource type (e.g., Virtual Machines)
resource "azurerm_security_center_subscription_pricing" "example" {
  resource_type = "VirtualMachines"
  tier          = "Standard"
}

# Configure a Security Center Contact to receive alerts
resource "azurerm_security_center_contact" "example" {
  resource_group_name = azurerm_resource_group.example.name
  email               = "security@example.com"
  name               = "vm-notifications"
  alert_notifications = true
  alerts_to_admins    = true
}
