module "multi_cloud_security" {
  source = "./security_module"

  aws_vpc_id          = "vpc-12345678"
  azure_subnet_id      = "/subscriptions/abc/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/subnet1"
  gcp_network_id       = "projects/my-project/global/networks/default"

  # Add other configuration parameters specific to each cloud provider as needed
}
