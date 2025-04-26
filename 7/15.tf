resource "google_service_account" "app_service_account" {
  account_id   = "app-service-account"
  display_name = "App Service Account"
}

resource "google_service_account_iam_binding" "binding" {
  service_account_id = google_service_account.app_service_account.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["user:admin@example.com"]
}
