provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "primary" {
  provider = aws.primary

  description             = "Multi-Region primary key"
  deletion_window_in_days = 30
  multi_region            = true
}

resource "aws_kms_replica_key" "replica" {
  description             = "Multi-Region replica key"
  deletion_window_in_days = 7
  primary_key_arn         = aws_kms_key.primary.arn
}
