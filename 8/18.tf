resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Enable blob versioning to preserve historical snapshots of stored data
  enable_blob_versioning   = true
}

resource "azurerm_storage_container" "compliance" {
  name                  = "compliance-reports"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "compliance_report" {
  # Use a timestamp to generate a unique filename for each report version
  name                   = "compliance_report_${timestamp()}.json"
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.compliance.name
  type                   = "Block"
  # Path to the local compliance report file that will be uploaded
  source                 = "path/to/report.json"
}
