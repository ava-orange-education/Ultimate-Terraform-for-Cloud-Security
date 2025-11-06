# Allow internal traffic for production resources on specific ports (HTTP and HTTPS)
resource "google_compute_firewall" "allow_internal" {
  name      = "allow-internal-traffic"
  network   = google_compute_network.main.id
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["10.0.0.0/16"]
  target_tags   = ["prod"]
}

# Deny all external traffic for production resources
resource "google_compute_firewall" "deny_external" {
  name      = "deny-external-traffic"
  network   = google_compute_network.main.id
  direction = "INGRESS"
  priority  = 2000

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["prod"]
}
