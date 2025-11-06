#AWS
resource "aws_kms_key" "example" {
  enable_key_rotation = true
}

#Azure
resource "azurerm_key_vault_key" "example" {
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
  rotation_policy {
    automatic = true
  }
}

#GCP
resource "google_kms_crypto_key" "example" {
  rotation_period = "7776000s"  // 90 days
}
