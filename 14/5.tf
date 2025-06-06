#network/main.tf
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "envs/prod/network"
  }
}

variable "vpc_name" {
  default = "prod-vpc"
}

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

output "vpc_network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}
