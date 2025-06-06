resource "azurerm_traffic_manager_profile" "dr_profile" {
  name                = "example-traffic-manager"
  resource_group_name = azurerm_resource_group.example.name
  traffic_routing_method = "Priority"

  dns_config {
    relative_name = "example-tm"
    ttl          = 30
  }

  monitor_config {
    protocol   = "HTTP"
    port       = 80
    path       = "/health"
  }
}

resource "azurerm_traffic_manager_endpoint" "primary" {
  name               = "primary-endpoint"
  profile_id         = azurerm_traffic_manager_profile.dr_profile.id
  type               = "AzureEndpoints"
  target_resource_id = azurerm_app_service.primary.id
  priority           = 1
}

resource "azurerm_traffic_manager_endpoint" "backup" {
  name               = "backup-endpoint"
  profile_id         = azurerm_traffic_manager_profile.dr_profile.id
  type               = "AzureEndpoints"
  target_resource_id = azurerm_app_service.backup.id
  priority           = 2
}
