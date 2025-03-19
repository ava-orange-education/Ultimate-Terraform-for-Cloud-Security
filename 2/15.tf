resource "google_storage_bucket" "shared" {
  name     = "shared-state"
  location = "US"

  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.shared.name
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:dev-access@my-project.iam.gserviceaccount.com",
    "serviceAccount:prod-access@my-project.iam.gserviceaccount.com"
  ]
}
