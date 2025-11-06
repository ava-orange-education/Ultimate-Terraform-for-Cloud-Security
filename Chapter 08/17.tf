output "gcp_compliance_report" {
  value = jsonencode(google_project_iam_policy.my_policy)
}

provisioner "local-exec" {
  command = "echo '${self.value}' > compliance_report.json"
}
