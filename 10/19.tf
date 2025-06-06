# Provision an Azure Front Door instance
resource "azurerm_frontdoor" "example" {
  name                = "example-frontdoor"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  backend_pool {
    name = "example-backend-pool"
    backend {
      address   = azurerm_storage_account.example.primary_web_endpoint
      http_port = 80
      https_port = 443
      priority  = 1
      weight    = 50
    }
  }

  frontend_endpoint {
    name      = "example-frontend"
    host_name = "example.azurefd.net"
  }

  routing_rule {
    name               = "example-routing-rule"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = [azurerm_frontdoor.example.frontend_endpoint[0].name]
    route_configuration {
      forwarding_configuration {
        backend_pool_name = azurerm_frontdoor.example.backend_pool[0].name
      }
    }
  }
}

# Create an Azure WAF Policy
resource "azurerm_web_application_firewall_policy" "example" {
  name                = "example-waf-policy"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  custom_rules {
    name      = "BlockBadBots"
    priority  = 1
    rule_type = "MatchRule"
    match_conditions {
      match_variables {
        variable_name = "RequestHeader"
        selector      = "User-Agent"
      }
      operator     = "Contains"
      match_values = ["BadBot"]
    }
    action = "Block"
  }
}

# Link the WAF Policy to the Front Door instance
resource "azurerm_frontdoor_firewall_policy_link" "example_link" {
  frontdoor_id                        = azurerm_frontdoor.example.id
  web_application_firewall_policy_id  = azurerm_web_application_firewall_policy.example.id
}
