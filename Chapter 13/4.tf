# Primary Backup Vault in us-east-1
resource "aws_backup_vault" "primary" {
  name        = "primary-backup-vault"
  kms_key_arn = var.kms_key_arn
}

# Replica Backup Vault in us-west-2 (using provider alias for us-west-2)
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_backup_vault" "replica" {
  provider    = aws.west
  name        = "replica-backup-vault"
  kms_key_arn = var.kms_key_arn_replica
}

# AWS Backup Plan for EBS volumes
resource "aws_backup_plan" "ebs_backup_plan" {
  name = "ebs-backup-plan"

  rule {
    rule_name         = "daily-ebs-backup"
    target_vault_name = aws_backup_vault.primary.name
    schedule          = "cron(0 5 * * ? *)"  # Every day at 5 AM UTC
    lifecycle {
      delete_after = 7  # Retain backups for 7 days
    }
    copy_action {
      destination_vault_arn = aws_backup_vault.replica.arn

      lifecycle {
        delete_after = 30  # Retain copies in the replica vault for 30 days
      }
    }
  }
}

# AWS Backup Selection for EBS volumes tagged for backup
resource "aws_backup_selection" "ebs_backup_selection" {
  plan_id      = aws_backup_plan.ebs_backup_plan.id
  name         = "ebs-backup-selection"
  iam_role_arn = var.backup_role_arn

  selection_tag {
    key   = "Backup"
    value = "true"
    type  = "STRINGEQUALS"
  }
}
