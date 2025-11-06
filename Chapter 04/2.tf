#AWS
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/MyTerraformRole"
    session_name = "terraform-session"
  }
}

#GCP
provider "google" {
  region = "us-central1"
  credentials = jsonencode({
    "type": "external_account",
    "audience": "//iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/POOL_ID/providers/PROVIDER_ID",
    "subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
    "token_url": "https://sts.googleapis.com/v1/token",
    "credential_source": {
      "file": "/path/to/oidc-token-file"
    }
  })
}

#Azure
provider "azurerm" {
  features {}
  use_msi = true
  subscription_id = "00000000-0000-0000-0000-000000000000"
}
