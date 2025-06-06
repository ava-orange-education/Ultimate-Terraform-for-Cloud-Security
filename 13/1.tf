# Create an IAM role for AWS DLM to manage snapshots
resource "aws_iam_role" "dlm_role" {
  name = "dlm-lifecycle-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "dlm.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach a policy to the IAM role with the required permissions for DLM
resource "aws_iam_role_policy" "dlm_policy" {
  name = "dlm-policy"
  role = aws_iam_role.dlm_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots"
        ],
        Resource = "*"
      }
    ]
  })
}

# Create a Data Lifecycle Manager (DLM) lifecycle policy for EBS snapshots
resource "aws_dlm_lifecycle_policy" "ebs_snapshot_policy" {
  description         = "Automated daily snapshot policy for EBS volumes with Backup=true tag"
  execution_role_arn  = aws_iam_role.dlm_role.arn
  state               = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]
    target_tags = {
      backup = "true"
    }

    schedules {
      name      = "daily-snapshot"
      copy_tags = true

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
      }

      retain_rule {
        count = 7
      }
    }
  }
}
