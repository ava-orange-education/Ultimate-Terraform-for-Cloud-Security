module "iam_compliance" {
  source         = "./modules/iam_compliance"
  aws_account_id = var.account_id
}

output "iam_report" {
  value = module.iam_compliance.report
}
