# Retrieve the current client configuration
data "azurerm_client_config" "current" {}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "hipaa-rg"
  location = "East US"
}

# Create a Log Analytics Workspace for diagnostics
resource "azurerm_log_analytics_workspace" "example" {
  name                = "hipaa-law"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create a Key Vault for managing encryption keys
resource "azurerm_key_vault" "example" {
  name                = "hipaa-kv"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# Create a Key Vault Key for encryption
resource "azurerm_key_vault_key" "example" {
  name         = "hipaa-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
}

# Create a HIPAA-compliant Storage Account with enforced encryption and secure transfer
resource "azurerm_storage_account" "example" {
  name                     = "hipaastorageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true

  encryption {
    services {
      blob {
        enabled = true
      }
      file {
        enabled = true
      }
    }
    key_source = "Microsoft.Keyvault"
    key_vault_properties {
      key_name     = azurerm_key_vault_key.example.name
      key_version  = azurerm_key_vault_key.example.version
      key_vault_id = azurerm_key_vault.example.id
    }
  }
}

# Restrict access by applying network rules that deny public access and allow only internal IP ranges
resource "azurerm_storage_account_network_rules" "example" {
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_name = azurerm_storage_account.example.name

  default_action             = "Deny"
  bypass                     = ["AzureServices"]
  ip_rules                   = ["10.0.0.0/16"]
}

# Enable diagnostic settings for logging and monitoring
resource "azurerm_monitor_diagnostic_setting" "example" {
  name                       = "hipaa-diagnostics"
  target_resource_id         = azurerm_storage_account.example.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "StorageRead"
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
