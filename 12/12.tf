# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

# Create a Log Analytics Workspace for storing logs
resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-law"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create an Event Hub Namespace for log export (to be ingested by ELK)
resource "azurerm_eventhub_namespace" "example" {
  name                = "example-ehns"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 2
}

# Create an Event Hub within the Namespace
resource "azurerm_eventhub" "example" {
  name                = "example-eh"
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 4
  message_retention   = 1
}

# Create an Event Hub Authorization Rule for access control
resource "azurerm_eventhub_authorization_rule" "example" {
  name                = "example-auth-rule"
  namespace_name      = azurerm_eventhub_namespace.example.name
  eventhub_name       = azurerm_eventhub.example.name
  resource_group_name = azurerm_resource_group.example.name
  listen              = true
  send                = true
  manage              = false
}

# Provision an Azure Storage Account as the source of logs
resource "azurerm_storage_account" "example" {
  name                     = "examplestoracc"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Configure Diagnostic Settings to send logs to both Log Analytics and Event Hub
resource "azurerm_monitor_diagnostic_setting" "example" {
  name                       = "diag-setting"
  target_resource_id         = azurerm_storage_account.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  eventhub_authorization_rule_id = azurerm_eventhub_authorization_rule.example.id
  eventhub_name                  = azurerm_eventhub.example.name

  log {
    category = "StorageRead"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
