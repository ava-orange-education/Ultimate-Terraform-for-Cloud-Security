# Define a custom Azure role for CI/CD pipelines with least privilege access
resource "azurerm_role_definition" "ci_cd_role" {
  name               = "CI/CD Pipeline Role"
  scope              = azurerm_resource_group.example.id
  description        = "Custom role for CI/CD pipeline with limited permissions to deploy resources in a specific resource group"
  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/deployments/*",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Storage/storageAccounts/read"
    ]
    not_actions = []
  }
  assignable_scopes = [
    azurerm_resource_group.example.id
  ]
}

# Assign the custom role to a CI/CD service principal (or managed identity)
resource "azurerm_role_assignment" "ci_cd_role_assignment" {
  principal_id       = data.azurerm_client_config.current.object_id
  role_definition_id = azurerm_role_definition.ci_cd_role.id
  scope              = azurerm_resource_group.example.id
}

data "azurerm_client_config" "current" {}
