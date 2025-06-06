# AWS provider configuration
provider "aws" {
  region = "us-east-1"
}

# Azure provider configuration
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}

# GCP provider configuration
provider "google" {
  project = var.gcp_project
  region  = "us-central1"
}

# Module invocation to deploy quarantine VMs across clouds
module "quarantine_vm" {
  source = "./modules/quarantine_vm"

  instance_name = "quarantine-vm"
  aws_ami       = var.aws_ami
  aws_instance_type = var.aws_instance_type
  azure_resource_group = var.azure_resource_group
  azure_location       = var.azure_location
  azure_vm_size        = var.azure_vm_size
  azure_image_publisher= var.azure_image_publisher
  azure_image_offer    = var.azure_image_offer
  azure_image_sku      = var.azure_image_sku
  azure_admin_username = var.azure_admin_username
  azure_admin_password = var.azure_admin_password
  gcp_zone       = var.gcp_zone
  gcp_machine_type = var.gcp_machine_type
  gcp_image         = var.gcp_image

  providers = {
    aws    = aws
    azurerm = azurerm
    google  = google
  }
}
