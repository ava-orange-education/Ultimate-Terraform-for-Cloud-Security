# modules/network/main.tf
resource "google_compute_network" "vpc" {
  name                    	= "custom-vpc"
  auto_create_subnetworks 	= false
  routing_mode            		= "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name          	= "custom-subnet"
  network       	= google_compute_network.vpc.id
  ip_cidr_range 	= var.vpc_cidr
  region        	= "us-central1"
}

# modules/network/variables.tf
variable "vpc_cidr" {
  description 	= "CIDR block for the VPC"
  type        	= string
}

# modules/network/outputs.tf
output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
}

# Calling the module in the root configuration
module "network" {
  source   	= "./modules/network"
  vpc_cidr 	= "10.1.0.0/16"
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_id" {
  value = module.network.subnet_id
}
