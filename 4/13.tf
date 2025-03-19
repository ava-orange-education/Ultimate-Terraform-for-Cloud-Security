resource "google_project_iam_binding" "example" {
  project = "my-gcp-project"
  role    = "roles/viewer"
  
  members = [
    "user:example-user@example.com",
    "group:group@example.com"
  ]
}

resource "google_iam_policy" "external_identity_policy" {
  bindings = [
    {
      role    = "roles/storage.objectViewer"
      members = [
        "principal://okta.com/identity/your-id-provider"
      ]
    }
  ]
}
