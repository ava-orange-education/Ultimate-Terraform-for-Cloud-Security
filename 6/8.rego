package terrascan.gcp.storage

# Default is to deny if conditions are not met.
default allow = false

# Allow if the resource is a Google Storage Bucket with UBLA enabled.
allow {
    input.resource_type == "google_storage_bucket"
    # Check that the attribute for uniform bucket-level access exists and is enabled.
    input.parsed_body.uniform_bucket_level_access.enabled == true
}
