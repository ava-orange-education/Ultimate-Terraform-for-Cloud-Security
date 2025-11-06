resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS key for S3 encryption"
  enable_key_rotation     = true
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-data-storage"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_encryption_key.id
      }
    }
  }
}
