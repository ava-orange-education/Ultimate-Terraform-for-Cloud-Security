resource "consul_service" "example" {
  name = "multi-cloud-compliance"
  tags = ["aws", "azure", "gcp"]
  address = "10.0.0.1"
}
