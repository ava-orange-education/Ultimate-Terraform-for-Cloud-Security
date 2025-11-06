resource "google_storage_bucket" "example" {
  name     = "example-bucket"
  location = "US"

  labels = {
    exception_approved = "true"
    expiry_date        = "2024-03-01"
  }
}
