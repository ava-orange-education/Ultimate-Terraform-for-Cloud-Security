resource "google_storage_bucket" "example" {
  name     = "example-bucket"
  location = "US"
  uniform_bucket_level_access = true
}
