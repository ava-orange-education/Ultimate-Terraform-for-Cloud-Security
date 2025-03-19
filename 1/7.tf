#AssumeRole for Terraform in AWS:
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/TerraformRole"
  }
}

#IAM for Terraform Service Account in GCP
resource "google_service_account" "terraform" {
  account_id   = "terraform-admin"
  display_name = "Terraform Admin"
}

#RBAC for Terraform in Azure
resource "azurerm_role_assignment" "terraform_role" {
  scope                = azurerm_resource_group.example.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.example.id
}
