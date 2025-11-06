#AWS S3 
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"  # DynamoDB table for state locking
    encrypt        = true  # Enable encryption at rest
  }
}

#Azure Blob Storage
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-backend"
    storage_account_name  = "tfstateaccount"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
    cosmosdb_lock_name    = "terraform-lock"  # Cosmos DB for state locking
  }
}

#GCP Bucket
terraform {
  backend "gcs" {
    bucket  = "my-terraform-state"
    prefix  = "infra/state"
    project = "my-gcp-project"
    lock_table = "terraform-lock"  # Firestore for state locking
  }
}
