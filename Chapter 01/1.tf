resource "aws_ebs_volume" "example" {
  size              = 40
  availability_zone = "us-west-2a"
  encrypted         = true
}
