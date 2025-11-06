package terraform.gcp

deny[msg] {
  input.resource_type == "google_storage_bucket"
  not input.resource.attributes.iamConfiguration.uniformBucketLevelAccess.enabled
  msg = "GCP storage buckets must have uniform bucket-level access enabled to prevent public access."
}
