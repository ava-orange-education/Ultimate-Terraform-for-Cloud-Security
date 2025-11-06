# Create a GCP Storage Bucket with Versioning for Terraform State
resource "google_storage_bucket" "terraform_state" {
  name          = "my-terraform-state-bucket-unique"  # Bucket name must be unique globally
  location      = "US"
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90  # Optional: delete older object versions after 90 days to manage cost.
    }
  }
}

# Configure Terraform to use the versioned storage bucket as the remote backend
terraform {
  backend "gcs" {
    bucket = google_storage_bucket.terraform_state.name
    prefix = "terraform/state"
  }
}
