resource "google_project_iam_custom_role" "minimal_storage_viewer" {
  role_id     = "minimalStorageViewer"
  title       = "Minimal Storage Viewer"
  description = "Custom role with minimal permissions for viewing storage buckets"
  project     = "my-project-id"

  permissions = [
    "storage.buckets.get",
    "storage.objects.get",
    "storage.objects.list"
  ]
}
