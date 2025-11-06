#AWS-Specific Feature (EC2 Spot Instances):
resource "aws_instance" "spot" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.medium"
  spot_price    = "0.040"
}

#Azure-Specific Feature (Resource Groups):
resource "azurerm_resource_group" "rg" {
  name     = "example-resources"
  location = "East US"
}

#GCP-Specific Feature (Preemptible VMs):
resource "google_compute_instance" "vm" {
  name         = "preemptible-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  scheduling {
    preemptible       = true
    automatic_restart = false
  }
}
