variable "cloud_provider" {
  type = string
}

resource "aws_instance" "example" {
  count = var.cloud_provider == "aws" ? 1 : 0
  ami           = "ami-123456"
  instance_type = "t2.micro"
}

resource "azurerm_virtual_machine" "example" {
  count = var.cloud_provider == "azure" ? 1 : 0
  name                = "examplevm"
  location            = "East US"
  resource_group_name = "example-rg"
  size                = "Standard_B1s"
}

resource "google_compute_instance" "example" {
  count = var.cloud_provider == "gcp" ? 1 : 0
  name         = "example-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
}
