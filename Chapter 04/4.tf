provider "aws" {
  alias  = "dev"
  region = "us-east-1"
  profile = "dev-account"
}

provider "aws" {
  alias  = "prod"
  region = "us-west-2"
  profile = "prod-account"
}
