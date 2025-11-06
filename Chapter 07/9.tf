resource "azurerm_role_definition" "minimal_storage_viewer" {
  name        = "MinimalStorageViewer"
  scope       = azurerm_resource_group.example.id
  description = "Custom role with minimal permissions for viewing storage accounts"
  
  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/read"
    ]
    not_actions = []
  }
  
  assignable_scopes = [
    azurerm_resource_group.example.id
  ]
}
