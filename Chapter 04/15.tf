resource "azurerm_storage_account" "sovereign_storage" {
  name                     = "sovereignstorage"
  resource_group_name      = "sovereign-rg"
  location                 = "UK South"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    environment = "production"
    compliance  = "UK-GDPR"
  }
}
