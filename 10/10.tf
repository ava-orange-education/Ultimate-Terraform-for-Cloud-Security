resource "google_compute_security_policy" "bad_ips" {
  name = "bad-ip-list-policy"

  rule {
    action   = "deny(403)"
    priority = 1000

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["203.0.113.10/32", "203.0.113.20/32"]
      }
    }
  }
}
