resource "azurerm_role_definition" "example" {
  name        = "example-custom-role"
  scope       = azurerm_resource_group.example.id
  description = "Custom role for example purposes"
  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Compute/virtualMachines/start/action",
    ]
    not_actions = []
  }
  assignable_scopes = [
    azurerm_resource_group.example.id
  ]
}

resource "azurerm_role_assignment" "example" {
  scope              = azurerm_resource_group.example.id
  role_definition_id = azurerm_role_definition.example.id
  principal_id       = azuread_user.example.id
}
