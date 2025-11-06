#AWS
resource "aws_config_config_rule" "encrypted_volumes" {
  name = "encrypted-volumes"
  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }
}

#Azure
resource "azurerm_policy_assignment" "require_tls" {
  name                 = "require-tls"
  policy_definition_id = azurerm_policy_definition.enforce_tls.id
  scope                = azurerm_subscription.example.id
}


#GCP
resource "google_project_iam_policy" "policy_enforcement" {
  project     = "example-project"
  policy_data = file("policy.json")
}

