resource "grafana_data_source" "cloudwatch_assumeARN" {
  type = "cloudwatch"
  name = "cw-assumeARN-example"

  json_data_encoded = jsonencode({
    defaultRegion = "us-east-1"
    authType      = "grafana_assume_role"
    assumeRoleArn = "arn:aws:iam:: ${var.aws_account_id}:role/${var.assume_role}"
  })
}
