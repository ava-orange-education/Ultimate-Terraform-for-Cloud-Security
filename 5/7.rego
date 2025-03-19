package azure.nsg
default allow = false
allow {
  input.resource.type == "azurerm_network_security_group"
  some rule
  input.resource.properties.security_rules[rule].access == "Deny"
}
