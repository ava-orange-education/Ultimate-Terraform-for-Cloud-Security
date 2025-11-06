resource "google_compute_security_policy" "incident_response" {
  name        = "incident-response-policy"
  description = "Security policy to block anomalous traffic during incidents"
  
  rule {
    priority = 1000
    action   = "deny(403)"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["10.1.2.3/32"]  # Placeholder IP; replace dynamically during an incident
      }
    }
  }
}
