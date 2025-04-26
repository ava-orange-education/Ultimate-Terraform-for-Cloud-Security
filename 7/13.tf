#main.tf
variable "cloud" {}

resource "aws_iam_role" "iam_role" {
  count = var.cloud == "aws" ? 1 : 0
  name  = "multi-cloud-role"
  assume_role_policy = file("aws_trust.json")
}

resource "google_project_iam_member" "iam_binding" {
  count   = var.cloud == "gcp" ? 1 : 0
  project = "example-project"
  role    = "roles/viewer"
  member  = "user:jane@example.com"
}

resource "azurerm_role_assignment" "iam_assignment" {
  count               = var.cloud == "azure" ? 1 : 0
  scope               = azurerm_resource_group.rg.id
  role_definition_id  = data.azurerm_role_definition.reader.id
  principal_id        = azurerm_user_assigned_identity.identity.id
}
