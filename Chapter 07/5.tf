# Assign Viewer role at the folder level for the engineering team
resource "google_folder_iam_member" "engineering_viewer" {
  folder_id = "1234567890"  # Replace with your Folder ID
  role      = "roles/viewer"
  member    = "group:engineering-team@example.com"
}

# Assign Storage Admin role at the project level for the CI/CD service account
resource "google_project_iam_member" "storage_admin" {
  project = "my-project-123456"  # Replace with your Project ID
  role    = "roles/storage.admin"
  member  = "serviceAccount:ci-cd-service@my-project-123456.iam.gserviceaccount.com"
}
