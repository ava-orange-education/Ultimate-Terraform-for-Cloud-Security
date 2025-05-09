# Create a secret in GCP Secret Manager
resource "google_secret_manager_secret" "example" {
  secret_id   = "example-secret"
  replication {
    automatic = true
  }
}

# Create an initial version of the secret
resource "google_secret_manager_secret_version" "example_version" {
  secret      = google_secret_manager_secret.example.id
  secret_data = base64encode("initial-secret-data")
}

# Create a Pub/Sub topic to trigger the rotation
resource "google_pubsub_topic" "rotate_topic" {
  name = "secret-rotation-topic"
}

# Create a storage bucket to hold the Cloud Function source code
resource "google_storage_bucket" "function_bucket" {
  name          = "function-source-bucket-${random_id.bucket_suffix.hex}"
  location      = "us-central1"
  force_destroy = true
}

# Generate a random suffix for the bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Upload the Cloud Function source code to the bucket
resource "google_storage_bucket_object" "function_zip" {
  name   = "rotate_secret_function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "path/to/rotate_secret_function.zip"  # Path to your function zip file
}

# Create a Cloud Function to handle secret rotation
resource "google_cloudfunctions_function" "rotate_secret" {
  name                  = "rotateSecretFunction"
  description           = "Rotates the secret in Secret Manager"
  runtime               = "python39"
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_zip.name
  entry_point           = "rotate_secret"  # Python function name in your code

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.rotate_topic.id
  }
}

# Schedule the Cloud Function to run every 30 days via Cloud Scheduler
resource "google_cloud_scheduler_job" "rotate_job" {
  name        = "secret-rotation-job"
  description = "Triggers secret rotation every 30 days"
  schedule    = "0 0 */30 * *"  # Every 30 days
  time_zone   = "UTC"

  pubsub_target {
    topic_name = google_pubsub_topic.rotate_topic.name
    data       = base64encode("trigger rotation")
  }
}
