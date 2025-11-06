package azure_security  
default allow = false  
allow {  
  input.resource.type == "azurerm_network_security_group"  
  input.resource.properties.security_rules[_].access == "Deny"  
}
