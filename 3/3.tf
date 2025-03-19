module "network" {
  source = "./modules/network"
}

module "application" {
  source    = "./modules/app"
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.subnet_id
}

module "database" {
  source    = "./modules/db"
  vpc_id    = module.network.vpc_id
  depends_on = [module.application]
}
