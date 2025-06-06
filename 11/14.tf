# Provision an App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create the Production App Service (Blue Environment)
resource "azurerm_app_service" "blue" {
  name                = "example-app-blue"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "https://example.com/blue.zip"
  }
}

# Create a Deployment Slot for the Green Environment
resource "azurerm_app_service_slot" "green" {
  name                = "green"
  app_service_name    = azurerm_app_service.blue.name
  resource_group_name = azurerm_app_service.blue.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.example.id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "https://example.com/green.zip"
  }
}
