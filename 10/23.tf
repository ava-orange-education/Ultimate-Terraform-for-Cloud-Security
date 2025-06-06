resource "google_compute_security_policy" "example" {
  name = "dynamic-policy"

  rule {
    action   = "deny(403)"
    priority = 1000
    match {
      config {
        src_ip_ranges = ["203.0.113.0/24"]
      }
    }
  }
}
