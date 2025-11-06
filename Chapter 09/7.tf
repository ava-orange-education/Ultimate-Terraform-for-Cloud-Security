resource "google_kms_key_ring" "multi_region" {
  name     = "example-key-ring"
  location = "us"  # Multi-region location; 'us' represents a multi-region in GCP
}

resource "google_kms_crypto_key" "example" {
  name     = "example-key"
  key_ring = google_kms_key_ring.multi_region.id
  purpose  = "ENCRYPT_DECRYPT"
  rotation_period = "7776000s"  # Rotate every 90 days
}
