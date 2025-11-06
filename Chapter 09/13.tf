data "azurerm_key_vault_secret" "example" {
  name         = "db-password"
  key_vault_id = azurerm_key_vault.example.id
}

output "db_password" {
  value     = data.azurerm_key_vault_secret.example.value
  sensitive = true
}
