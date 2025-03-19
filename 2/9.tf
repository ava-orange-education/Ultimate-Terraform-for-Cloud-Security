#AWS
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

#Azure 
resource "azurerm_cosmosdb_sql_container" "terraform_lock" {
  name              = "terraform-lock"
  resource_group_name = "my-resource-group"
  cosmosdb_account_name = "my-cosmosdb-account"
  database_name     = "terraform-state"
  partition_key_path = "/LockID"
  throughput         = 400
}

#GCP 
resource "google_firestore_collection" "terraform_lock" {
  collection_id = "terraform-lock"
  project       = "my-gcp-project"
}
