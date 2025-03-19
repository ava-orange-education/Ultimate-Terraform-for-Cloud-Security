package cross_cloud.data_protection

deny[msg] {
  input.resource.type == "aws_s3_bucket"
  input.resource.region != "us-east-1"
  msg = "AWS S3 buckets must be created in us-east-1"
}

deny[msg] {
  input.resource.type == "azurerm_storage_account"
  input.resource.location != "eastus"
  msg = "Azure Storage accounts must be created in eastus"
}

deny[msg] {
  input.resource.type == "google_storage_bucket"
  input.resource.location != "us-central1"
  msg = "GCP Storage buckets must be created in us-central1"
}
