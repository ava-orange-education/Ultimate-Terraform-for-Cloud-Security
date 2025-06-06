# Create an Azure Event Grid Topic
resource "azurerm_eventgrid_topic" "security_alerts" {
  name                = "security-alerts-topic"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

# Create an Azure Event Grid Subscription to trigger on non-compliant resources
resource "azurerm_eventgrid_event_subscription" "policy_alerts" {
  name                = "policy-noncompliance-sub"
  scope               = "/providers/Microsoft.PolicyInsights/policyStates/latest"  # Monitors policy state changes
  event_delivery_schema = "EventGridSchema"

  webhook_endpoint {
    url = "https://example.com/security-alert-webhook"  # Replace with actual webhook
  }
}

# Example: Azure Policy Definition to Enforce Compliance
resource "azurerm_policy_definition" "restrict_public_ip" {
  name         = "restrict-public-ip"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Restrict Public IP for VMs"

  policy_rule = jsonencode({
    if = {
      field = "Microsoft.Network/publicIPAddresses"
      exists = "true"
    }
    then = {
      effect = "deny"
    }
  })
}

# Assign the policy to a resource group
resource "azurerm_policy_assignment" "restrict_public_ip_assign" {
  name                 = "restrict-public-ip-assignment"
  policy_definition_id = azurerm_policy_definition.restrict_public_ip.id
  scope               = azurerm_resource_group.example.id
}
