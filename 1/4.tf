provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = "my-project"
}

provider "azurerm" {
  features {}
}

resource "aws_security_group" "web" {
  name_prefix = "web-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "google_compute_firewall" "http_firewall" {
  name    = "allow-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "azurerm_network_security_rule" "http_rule" {
  name                        = "allow_http"
  resource_group_name         = "web-rg"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "*"
  destination_port_range      = "80"
}
