data "azurerm_key_vault_secret" "app_password" {
  name         = "app-password"
  key_vault_id = azurerm_key_vault.example.id
}

resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_settings = {
    "APP_PASSWORD" = data.azurerm_key_vault_secret.app_password.value
  }
}
