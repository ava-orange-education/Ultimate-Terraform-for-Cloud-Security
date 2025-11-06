resource "azurerm_management_group" "example" {
  name         = "example-mg"
  display_name = "Example Management Group"
}

resource "azurerm_management_group_subscription_association" "example" {
  management_group_id = azurerm_management_group.example.name
  subscription_id     = var.subscription_id
}

resource "azurerm_role_assignment" "example" {
  scope                = "/providers/Microsoft.Management/managementGroups/${azurerm_management_group.example.name}"
  role_definition_name = "Contributor"
  principal_id         = var.principal_id
}
