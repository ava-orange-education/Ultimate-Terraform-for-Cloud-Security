resource "google_project_iam_binding" "iap_binding" {
  project = "example-project"
  role    = "roles/iap.tunnelResourceAccessor"

  members = [
    "user:example@example.com"
  ]
}

resource "google_compute_firewall" "zero_trust_firewall" {
  name    = "zero-trust-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }

  target_tags = ["secure-access"]
}
