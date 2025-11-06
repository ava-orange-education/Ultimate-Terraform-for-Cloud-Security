#AWS
resource "aws_accessanalyzer_analyzer" "example" {
  analyzer_name = "example-analyzer"
  type          = "ACCOUNT"
}

#GCP
resource "google_iam_policy" "audit" {
  project     = "example-project"
  policy_data = jsonencode({
    auditConfigs = [{
      service = "allServices"
    }]
  })
}

#Azure
resource "azurerm_policy_definition" "deny_wildcards" {
  name         = "deny-wildcards"
  policy_type  = "Custom"
  mode         = "All"
  policy_rule  = file("deny-wildcards.json")
}
