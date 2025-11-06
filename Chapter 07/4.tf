# IAM Role in Account A (Trusting Account)
resource "aws_iam_role" "account_a_role" {
  name = "AccountA-CrossAccountRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::222222222222:role/AccountB-Role"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "account_a_policy" {
  name   = "AccountA-S3ReadPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:ListBucket", "s3:GetObject"],
      Resource = [
        "arn:aws:s3:::example-bucket",
        "arn:aws:s3:::example-bucket/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "account_a_attach" {
  policy_arn = aws_iam_policy.account_a_policy.arn
  role       = aws_iam_role.account_a_role.name
}

# IAM Role in Account B (Trusting Role that Assumes the Role in Account A)
resource "aws_iam_role" "account_b_role" {
  provider = aws.account_b

  name = "AccountB-Role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::111111111111:root"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
