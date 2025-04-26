resource "aws_iam_policy" "minimal_s3_read_only" {
  name        = "MinimalS3ReadOnlyPolicy"
  description = "Grants read-only access to a specific S3 bucket"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Resource": [
          "arn:aws:s3:::example-bucket",
          "arn:aws:s3:::example-bucket/*"
        ]
      }
    ]
  })
}
