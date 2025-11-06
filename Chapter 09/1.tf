#AWS
resource "aws_secretsmanager_secret" "example" {
  name        = "example-secret"
  description = "This secret contains example credentials"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = jsonencode({
    username = "admin"
    password = "supersecretpassword"
  })
}

#GCP
resource "google_secret_manager_secret" "example" {
  secret_id = "example-secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "example" {
  secret      = google_secret_manager_secret.example.id
  secret_data = base64encode("supersecretvalue")
}

#Azure
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_key_vault" "example" {
  name                = "examplekv"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  value        = "supersecretvalue"
  key_vault_id = azurerm_key_vault.example.id
}
