#AWS
resource "aws_acm_certificate" "example" {
  domain_name       = "example.com"
  validation_method = "DNS"
}

#GCP
resource "google_compute_managed_ssl_certificate" "example" {
  name    = "example-cert"
  managed {
    domains = ["example.com"]
  }
}

#Azure
resource "azurerm_app_service_certificate_order" "example" {
  name                = "example-cert-order"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  distinguished_name  = "CN=example.com"
  product_type        = "Standard"
}
