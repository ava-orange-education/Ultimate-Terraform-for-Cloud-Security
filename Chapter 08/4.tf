resource "google_compute_instance" "compliant_instance" {
  name         = "compliant-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"  # Replace with an appropriate image
    }
  }

  network_interface {
    network = "default"
    # By omitting the access_config block, no public IP is assigned.
  }

  labels = {
    compliance = "CIS_NIST"
  }
}
