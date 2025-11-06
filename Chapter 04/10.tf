module "cross_cloud_iam" {
  source = "./iam_module"
  aws_role_name = "aws-example-role"
  azure_role_name = "azure-example-role"
  gcp_role_name = "gcp-example-role"
}
