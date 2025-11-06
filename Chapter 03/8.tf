variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

#Hashicorp Vault
data "vault_generic_secret" "db_creds" {
  path = "secret/db"
}

#AWS Secret Manager
data "aws_secretsmanager_secret" "db_creds" {
  name = "db-credentials"
}

#Azure Vault Key
data "azurerm_key_vault_secret" "db_creds" {
  name         = "db-credentials"
  key_vault_id = azurerm_key_vault.example.id
}

#Google Secrets Manager
data "google_secret_manager_secret" "db_creds" {
  secret_id = "db-credentials"
}
