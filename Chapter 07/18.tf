resource "azurerm_role_definition" "restricted_role" {
  name        = "restricted-role"
  scope       = data.azurerm_subscription.primary.id
  permissions {
    actions = ["Microsoft.Compute/virtualMachines/read"]
  }
}

resource "null_resource" "fix_iam" {
  triggers = {
    drift_detection = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      terraform import azurerm_role_definition.restricted_role /subscriptions/${data.azurerm_subscription.primary.id}/providers/Microsoft.Authorization/roleDefinitions/${azurerm_role_definition.restricted_role.id}
    EOT
  }
}
