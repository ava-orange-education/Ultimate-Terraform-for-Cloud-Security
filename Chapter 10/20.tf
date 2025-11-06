# Create a Cloud Armor Security Policy to block malicious IPs
resource "google_compute_security_policy" "example" {
  name        = "example-api-security-policy"
  description = "Security policy to block malicious IPs from accessing the API"
  
  rule {
    priority = 1000
    action   = "deny(403)"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["203.0.113.0/24"]
      }
    }
  }
}

# Create an API Gateway API
resource "google_api_gateway_api" "example" {
  api_id = "example-api"
}

# Create an API Gateway API configuration using an OpenAPI document
resource "google_api_gateway_api_config" "example" {
  api       = google_api_gateway_api.example.id
  config_id = "v1"
  openapi_documents {
    document {
      path     = "openapi.yaml"
      contents = file("openapi.yaml")
    }
  }
}

# Deploy the API Gateway in a specific region
resource "google_api_gateway_gateway" "example" {
  gateway_id = "example-gateway"
  api_config = google_api_gateway_api_config.example.id
  location   = "us-central1"
}

# Create a backend service for the load balancer and attach Cloud Armor policy
resource "google_compute_backend_service" "api_backend" {
  name                  = "example-api-backend"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTPS"
  security_policy       = google_compute_security_policy.example.self_link

  # Note: In a real-world scenario, you would point to a proper backend such as a Compute Engine instance group or NEG linked to API Gateway.
  backend {
    group = google_api_gateway_gateway.example.self_link
  }
}

# Configure a URL map to route requests to the backend service
resource "google_compute_url_map" "api_url_map" {
  name            = "example-api-url-map"
  default_service = google_compute_backend_service.api_backend.self_link
}

# Create a target HTTPS proxy that uses the URL map
resource "google_compute_target_https_proxy" "api_https_proxy" {
  name            = "example-api-https-proxy"
  url_map         = google_compute_url_map.api_url_map.self_link
  ssl_certificates = ["your-ssl-cert-self_link"]  # Replace with your actual SSL certificate resource self-link
}

# Create a global forwarding rule to direct HTTPS traffic to the target proxy
resource "google_compute_global_forwarding_rule" "api_forwarding_rule" {
  name                  = "example-api-forwarding-rule"
  ip_address            = google_compute_global_address.lb_ip.address
  target                = google_compute_target_https_proxy.api_https_proxy.self_link
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
}
