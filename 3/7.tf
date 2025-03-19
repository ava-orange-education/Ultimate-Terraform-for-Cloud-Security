output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}


module "network" {
  source = "./modules/network"
}

output "network_vpc_id" {
  value = module.network.vpc_id
}
