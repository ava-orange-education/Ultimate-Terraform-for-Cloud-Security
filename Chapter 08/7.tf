resource "google_kms_key_ring" "my_keyring" {
  name     = "secure-keyring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "my_crypto_key" {
  name     = "secure-key"
  key_ring = google_kms_key_ring.my_keyring.id
  purpose  = "ENCRYPT_DECRYPT"
}

resource "google_compute_disk" "encrypted_disk" {
  name  = "encrypted-disk"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  size  = 100

  disk_encryption_key {
    kms_key_self_link = google_kms_crypto_key.my_crypto_key.id
  }
}
