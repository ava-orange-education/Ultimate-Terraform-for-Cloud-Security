# Define a secure VPC for PCI DSS compliance
resource "google_compute_network" "secure_vpc" {
  name                    = "pci-secure-vpc"
  auto_create_subnetworks = false
}

# Create a subnet within the secure VPC
resource "google_compute_subnetwork" "pci_subnet" {
  name          = "pci-subnet"
  region        = "us-central1"
  network       = google_compute_network.secure_vpc.id
  ip_cidr_range = "10.0.0.0/24"
}

# Define a firewall rule that only allows HTTP, HTTPS, and SSH traffic from a trusted IP range
resource "google_compute_firewall" "pci_firewall" {
  name    = "pci-firewall"
  network = google_compute_network.secure_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["203.0.113.0/24"]  # Replace with your trusted IP range
  target_tags   = ["pci-compliant"]
}

# Create a Compute Engine instance with encrypted boot disk
resource "google_compute_instance" "pci_instance" {
  name         = "pci-compliant-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
      # Enforce encryption at rest using a customer-managed key (if required)
      # For simplicity, using default encryption here. Use "disk_encryption_key" block for CMK.
    }
  }

  network_interface {
    network    = google_compute_network.secure_vpc.id
    subnetwork = google_compute_subnetwork.pci_subnet.id
    # Omitting the access_config block ensures that no public IP is assigned.
  }

  tags = ["pci-compliant"]

  labels = {
    compliance = "PCI_DSS"
  }
}

# (Optional) Configure logging via Cloud Logging for continuous monitoring and audit
resource "google_logging_project_sink" "pci_sink" {
  name        = "pci-compliance-logs"
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/pci_logs"
  filter      = "resource.type=\"gce_instance\" AND labels.compliance=\"PCI_DSS\""
  project     = "example-project-id"
}
