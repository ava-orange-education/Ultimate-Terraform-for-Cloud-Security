module "aws_secret" {
  source = "./aws-secret"
}

module "azure_secret" {
  source = "./azure-secret"
}

module "gcp_secret" {
  source = "./gcp-secret"
}
