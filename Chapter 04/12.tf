resource "azuread_service_principal" "example" {
  display_name = "example-service-principal"
  tags         = ["Environment=Production", "Project=X"]
}
