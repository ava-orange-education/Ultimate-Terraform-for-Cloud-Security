resource "google_compute_global_address" "example" {
  name         = "global-lb-address"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}
