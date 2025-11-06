#IAM
resource "aws_iam_policy" "s3_read_only_policy" {
  name        = "S3ReadOnlyPolicy"
  description = "Provides read-only access to objects in the specified S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = ["s3:GetObject"]
        Resource  = "arn:aws:s3:::example-bucket/*"
      }
    ]
  })
}

#KMS
resource "aws_kms_key" "s3_encryption_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_key_policy" "s3_encryption_policy" {
  key_id = aws_kms_key.s3_encryption_key.key_id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "s3-kms-policy"
    Statement = [
      {
        Sid       = "AllowRootAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action    = "kms:*"
        Resource  = "*"
      },
      {
        Sid       = "AllowS3BucketEncryption"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:role/kms-role"
        }
        Action    = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource  = "*"
      }
    ]
  })
}

#GuardDuty
resource "aws_guardduty_detector" "audit_account" {
  enable = true
}

resource "aws_guardduty_organization_admin_account" "org_admin" {
  admin_account_id = "123456789012" # Audit account ID
}

resource "aws_guardduty_member" "member_account" {
  account_id                = "987654321098" # Member account ID
  detector_id               = aws_guardduty_detector.audit_account.id
  email                     = "security@example.com"
  invite                    = true
  disable_email_notification = false
}

resource "aws_guardduty_organization_configuration" "org_config" {
  detector_id    = aws_guardduty_detector.audit_account.id
  auto_enable    = true
}
