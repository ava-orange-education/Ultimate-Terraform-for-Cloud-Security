# Define a dedicated IAM role for Terraform pipeline execution
resource "aws_iam_role" "pipeline_role" {
  name = "terraform-pipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"  # Assuming the pipeline is running in AWS CodeBuild
        }
      }
    ]
  })
}

# Attach a policy with least privilege required for the deployment
resource "aws_iam_role_policy" "pipeline_policy" {
  name   = "terraform-pipeline-policy"
  role   = aws_iam_role.pipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:UpdateStack"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Example of how the pipeline would assume the role using AWS STS (this is typically done in your CI/CD script)
# aws sts assume-role --role-arn arn:aws:iam::<account-id>:role/terraform-pipeline-role --role-session-name "TerraformSession"
