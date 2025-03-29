package terrascan.exception

default allow = false

allow {
  input.resource_type == "aws_s3_bucket"
  input.tags["exception_approved"] == "true"
}
