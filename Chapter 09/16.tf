#AWS
resource "aws_s3_bucket" "example" {
  bucket = "secure-data-bucket"
  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

#Azure
resource "azurerm_storage_account" "example" {
  name                     = "securestorage"
  resource_group_name      = "example-group"
  location                 = "West US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
}

#GCP
resource "google_storage_bucket" "example" {
  name          = "secure-data-bucket-gcp"
  location      = "US"
  force_destroy = true

  encryption {
    default_kms_key_name = google_kms_crypto_key.example.id
  }
}
