variable "team_policies" {
  type = map(string)
  default = {
    devops_team  = "arn:aws:iam::aws:policy/AdministratorAccess"
    security_team = "arn:aws:iam::aws:policy/SecurityAudit"
    finance_team  = "arn:aws:iam::aws:policy/Billing"
  }
}

resource "aws_iam_group" "teams" {
  for_each = var.team_policies
  name     = each.key
}

resource "aws_iam_policy_attachment" "attach" {
  for_each   = var.team_policies
  name       = "${each.key}_policy_attachment"
  groups     = [aws_iam_group.teams[each.key].name]
  policy_arn = each.value
}

resource "aws_iam_policy" "tag_based_policy" {
  name        = "tagged_policy"
  description = "IAM policy applied based on tags"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "ec2:DescribeInstances"]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Environment" = "production"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "tag_enforced" {
  name       = "tag_enforced_policy"
  groups     = ["devops_team"]
  policy_arn = aws_iam_policy.tag_based_policy.arn
} 
