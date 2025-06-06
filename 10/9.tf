# Create a Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-law"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Enable diagnostic settings for the NSG to capture firewall events
resource "azurerm_monitor_diagnostic_setting" "firewall_audit" {
  name                       = "nsg-firewall-audit"
  target_resource_id         = azurerm_network_security_group.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
