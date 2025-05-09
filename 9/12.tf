variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}