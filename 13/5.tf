# Main Azure SQL Server
resource "azurerm_sql_server" "primary" {
  name                         = "primary-sqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_admin_password
}

# Primary Database
resource "azurerm_sql_database" "primary_db" {
  name                = "primary-database"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_sql_server.primary.location
  server_name         = azurerm_sql_server.primary.name
  edition             = "Standard"
  requested_service_objective_name = "S1"
}

# Secondary Azure SQL Server for Geo-Replication
resource "azurerm_sql_server" "secondary" {
  name                         = "secondary-sqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = "West US"  # Different region for redundancy
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_admin_password
}

# Secondary Database (Replica) - Created implicitly by geo-replication
resource "azurerm_sql_database_replication_link" "geo_replication" {
  name                  = "replication-link"
  resource_group_name   = azurerm_resource_group.example.name
  server_name           = azurerm_sql_server.primary.name
  database_name         = azurerm_sql_database.primary_db.name
  partner_server_name   = azurerm_sql_server.secondary.name
  partner_database_name = azurerm_sql_database.primary_db.name
}
