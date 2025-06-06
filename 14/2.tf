// variables.tf
variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "network" {
  description = "Name of the VPC network to attach the firewall"
  type        = string
}

variable "allowed_services" {
  description = "List of protocols and port ranges to allow"
  type = list(object({
    protocol = string
    ports    = list(number)
  }))
  default = [
    { protocol = "tcp"; ports = [80, 443] },
    { protocol = "icmp"; ports = [] } // empty ports list means all ICMP
  ]
}

// locals.tf
locals {
  firewall_name = "${var.project}-app-fw"
  common_tags   = {
    project     = var.project
    managed_by  = "terraform"
  }
}

// main.tf
resource "google_compute_firewall" "app_fw" {
  name    = local.firewall_name
  project = var.project
  network = var.network

  // Dynamically generate one allow block per service definition
  dynamic "allow" {
    for_each = var.allowed_services
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  // Apply common tags as labels
  labels = local.common_tags
}
