# Testing backup restoration by creating a new database using Point-in-Time Restore mode
resource "azurerm_sql_database" "restored_db" {
  name                = "restoreddatabase"
  resource_group_name = azurerm_sql_server.primary.resource_group_name
  location            = azurerm_sql_server.primary.location
  server_name         = azurerm_sql_server.primary.name

  # Restore from the primary database using the Point-In-Time Restore mode.
  # In an actual scenario, the restore_point_in_time should be set to a valid backup timestamp.
  create_mode         = "PointInTimeRestore"
  source_database_id  = azurerm_sql_database.primary_db.id
  restore_point_in_time = "2023-01-01T00:00:00Z"  # Example timestamp; replace with an actual restore point.
}
