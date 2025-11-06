# Create a GCP Storage Bucket with a retention policy (e.g., 30 days)
resource "google_storage_bucket" "logs_bucket" {
  name          = "logs-bucket-unique"  # Ensure this name is globally unique
  location      = "US"
  force_destroy = true

  retention_policy {
    retention_period = 2592000  # Retain logs for 30 days (in seconds)
  }
}

# Create a Cloud Logging Project Sink that exports logs to the storage bucket
resource "google_logging_project_sink" "example" {  
  name        = "sink-example"  
  destination = "storage.googleapis.com/${google_storage_bucket.logs_bucket.name}"
}
