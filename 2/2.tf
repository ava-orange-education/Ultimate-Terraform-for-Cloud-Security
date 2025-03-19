terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "azurerm" {
  features {}
}

provider "google" {
  credentials = file("account.json")
  project     = "my-gcp-project"
  region      = "us-central1"
}
