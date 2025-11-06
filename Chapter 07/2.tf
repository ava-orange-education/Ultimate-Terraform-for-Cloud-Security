resource "google_service_account" "example" {
  account_id   = "example-sa"
  display_name = "Example Service Account"
}

resource "google_project_iam_binding" "example" {
  project = "my-project"
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.example.email}"
  ]
}
