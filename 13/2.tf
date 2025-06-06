provider "vault" {
  # Replace with your Vault address and token as appropriate
  address = "http://127.0.0.1:8200"
  token   = var.vault_token
}

# Create a Vault policy for managing Azure Blob backup secrets
resource "vault_policy" "azure_blob_backup_policy" {
  name   = "azure_blob_backup_policy"
  policy = <<EOT
path "secret/backup/azure/blob/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}

# Store a sample secret using the defined policy path
resource "vault_generic_endpoint" "azure_backup_secret" {
  path      = "secret/backup/azure/blob/my-secret"
  data_json = <<EOT
{
  "username": "admin",
  "password": "securepassword123"
}
EOT
}
