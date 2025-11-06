# Create a Key Ring for artifact encryption
resource "google_kms_key_ring" "artifact_key_ring" {
  name     = "artifact-key-ring"
  location = "us"
}

# Create a Crypto Key for encrypting stored artifacts
resource "google_kms_crypto_key" "artifacts_key" {
  name     = "artifacts-key"
  key_ring = google_kms_key_ring.artifact_key_ring.id
  purpose  = "ENCRYPT_DECRYPT"
}

# Provision a GCP Storage Bucket with encryption, versioning, and lifecycle rules
resource "google_storage_bucket" "artifact_bucket" {
  name          = "my-artifact-bucket-12345"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  encryption {
    default_kms_key_name = google_kms_crypto_key.artifacts_key.id
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}
