resource "google_secret_manager_secret" "example" {
  secret_id = "db-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "example_version" {
  secret      = google_secret_manager_secret.example.id
  secret_data = base64encode("supersecretpassword")
}

output "db_password" {
  value     = google_secret_manager_secret_version.example_version.secret_data
  sensitive = true
}
