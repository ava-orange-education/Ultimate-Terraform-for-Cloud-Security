resource "azurerm_key_vault" "example" {
  name                = "keyvault-example"
  location            = "East US"
  resource_group_name = "example-rg"
}

resource "azurerm_key_vault_secret" "example" {
  name         = "app-password"
  value        = "SuperSecret123"
  key_vault_id = azurerm_key_vault.example.id
}

resource "azurerm_automation_schedule" "example" {
  name                = "rotation-schedule"
  resource_group_name = "example-rg"
  frequency           = "Day"
  interval            = 30
}
