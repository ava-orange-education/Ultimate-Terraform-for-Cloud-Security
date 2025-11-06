# Create a Key Ring for GDPR-compliant encryption
resource "google_kms_key_ring" "gdpr_keyring" {
  name     = "gdpr-keyring"
  location = "us-central1"
}

# Create a Crypto Key for encrypting bucket data
resource "google_kms_crypto_key" "gdpr_key" {
  name     = "gdpr-key"
  key_ring = google_kms_key_ring.gdpr_keyring.id
  purpose  = "ENCRYPT_DECRYPT"
}

# Create a logging bucket to store access logs
resource "google_storage_bucket" "log_bucket" {
  name                          = "gdpr-log-bucket"
  location                      = "US"
  force_destroy                 = true
  uniform_bucket_level_access   = true
}

# Create the GDPR-compliant storage bucket
resource "google_storage_bucket" "gdpr_bucket" {
  name                          = "gdpr-compliant-bucket"
  location                      = "US"
  force_destroy                 = false
  uniform_bucket_level_access   = true

  # Enforce encryption at rest with a customer-managed key
  encryption {
    default_kms_key_name = google_kms_crypto_key.gdpr_key.id
  }

  # Enable logging for auditing access to the bucket
  logging {
    log_bucket        = google_storage_bucket.log_bucket.name
    log_object_prefix = "access-logs/"
  }

  labels = {
    compliance = "GDPR"
  }
}
