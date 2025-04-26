locals {
  current_workspace = terraform.workspace
}

# AWS Provider
provider "aws" {
  alias  = "aws"
  region = "us-west-2"
}

# GCP Provider
provider "google" {
  alias   = "gcp"
  project = "my-gcp-project"
  region  = "us-central1"
}

# Azure Provider
provider "azurerm" {
  alias           = "azure"
  features        = {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

############################
# AWS IAM Resource (if workspace is "aws")
############################
resource "aws_iam_role" "example" {
  count = local.current_workspace == "aws" ? 1 : 0

  name = "example-role-aws"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

############################
# GCP IAM Resource (if workspace is "gcp")
############################
resource "google_service_account" "example" {
  count = local.current_workspace == "gcp" ? 1 : 0

  account_id   = "example-sa-gcp"
  display_name = "Example Service Account"
}

############################
# Azure IAM Resource (if workspace is "azure")
############################
resource "azurerm_resource_group" "example" {
  count    = local.current_workspace == "azure" ? 1 : 0
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_role_assignment" "example" {
  count = local.current_workspace == "azure" ? 1 : 0

  scope                = azurerm_resource_group.example[0].id
  role_definition_name = "Contributor"
  principal_id         = "00000000-0000-0000-0000-000000000000"  # Replace with the actual principal ID
}
