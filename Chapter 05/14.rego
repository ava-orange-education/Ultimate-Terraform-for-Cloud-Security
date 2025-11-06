package gcp.tags
deny[msg] {
  input.resource.labels["Environment"] == ""
  msg = "GCP Resource must have an 'Environment' tag"
}
