resource "google_compute_instance_group" "canary_group" {
  name        = "canary-group"
  zone        = "us-central1-a"
  target_size = 1
}
