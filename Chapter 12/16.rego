package terraform.azure

deny[msg] {
  input.resource_type == "azurerm_public_ip"
  msg = "Public IP addresses are not allowed in this configuration."
}
