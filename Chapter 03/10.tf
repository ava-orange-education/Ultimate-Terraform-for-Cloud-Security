terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "project/${terraform.workspace}/terraform.tfstate"
    region = "us-east-1"
  }
}
