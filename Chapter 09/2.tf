resource "google_secret_manager_secret" "example" {
  secret_id = "example-secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_binding" "example_binding" {
  secret_id = google_secret_manager_secret.example.id
  role      = "roles/secretmanager.secretAccessor"
  members   = [
    "user:example@example.com",
    "serviceAccount:my-service-account@my-project.iam.gserviceaccount.com",
  ]
}
