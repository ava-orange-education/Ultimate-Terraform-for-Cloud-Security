#IAM
resource "google_project_iam_binding" "example" {
  project = "<project_id>"
  role    = "roles/storage.admin"

  members = [
    "user:example-user@example.com"
  ]
}

#KMS
resource "google_kms_key_ring" "example" {
  name     = "example-key-ring"
  location = "global"
  project  = "<project_id>"
}

resource "google_kms_crypto_key" "example" {
  name     = "example-key"
  key_ring = google_kms_key_ring.example.id
  project  = "<project_id>"

  rotation_period = "100000s"
  next_rotation_time = "2025-01-01T00:00:00Z"
}

#Security command center
resource "google_security_center_organization_settings" "example" {
  organization = "<organization_id>"
  enable_asset_discovery = true
} 
