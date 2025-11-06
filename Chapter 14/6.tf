#compute/main.tf
terraform {
  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "envs/prod/compute"
  }
}

data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = "my-terraform-state-bucket"
    prefix = "envs/prod/network"
  }
}

resource "google_compute_instance" "vm" {
  name         = "app-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = data.terraform_remote_state.network.outputs.vpc_network_name
    access_config {}
  }
}
