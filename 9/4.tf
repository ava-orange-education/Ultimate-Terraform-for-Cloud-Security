#AWS
resource "aws_kms_key" "example" {
  description             = "KMS key for secret encryption"
  deletion_window_in_days = 10
}

resource "aws_secretsmanager_secret" "secret" {
  name                    = "db-password"
  kms_key_id              = aws_kms_key.example.id
  recovery_window_in_days = 7
}

#Azure
resource "azurerm_key_vault" "example" {
  name                = "vault-example"
  location            = "East US"
  resource_group_name = "resource-group"
}

resource "azurerm_key_vault_key" "example" {
  name         = "key-example"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
}

#GCP
resource "google_kms_key_ring" "example" {
  name     = "example-key-ring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "example" {
  name     = "example-key"
  key_ring = google_kms_key_ring.example.id
  purpose  = "ENCRYPT_DECRYPT"
}
