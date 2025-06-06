resource "google_storage_bucket" "backup_bucket" {
  name          = "backup-bucket-unique"
  location      = "US"
  force_destroy = true

  retention_policy {
    retention_period = 2592000  # Retains backups for 30 days (in seconds)
  }
}
