resource "google_project_iam_binding" "example" {
  project = "my-gcp-project"
  role    = "roles/storage.objectViewer"
  members = [
    "user:jane@example.com",
    "serviceAccount:my-service-account@my-gcp-project.iam.gserviceaccount.com"
  ]
}
