module “network” {
  source = “./modules/network”
  vpc_cidr = “10.0.0.0/16”
}
