resource "grafana_data_source" "azure_monitor" {
  name = "Azure Monitor"
  type = "azuremonitor"

  json_data_encoded = <<JSON
{
  "azureCloud": "AzureCloud",
  "subscriptionId": "${var.azure_subscription_id}",
  "tenantId": "${var.azure_tenant_id}",
  "defaultWorkspace": "${var.azure_log_analytics_workspace_id}"
}
JSON

  secure_json_data_encoded = <<JSON
{
  "clientId": "${var.azure_client_id}",
  "clientSecret": "${var.azure_client_secret}"
}
JSON
}
