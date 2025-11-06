module "shared_security_policies" {
  source = "./security_module"
  
  aws_s3_bucket = {
    bucket_name = "example-bucket"
    public_access_block = true
    encryption = "AES256"
  }

  azure_storage_account = {
    account_name = "examplestorage"
    public_access = false
    encryption = "AES256"
  }

  gcp_storage_bucket = {
    bucket_name = "example-bucket-gcp"
    uniform_bucket_level_access = true
    encryption = "AES256"
  }
}
