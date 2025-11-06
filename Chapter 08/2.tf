resource "aws_instance" "compliant_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with an appropriate AMI
  instance_type = "t2.micro"
  associate_public_ip_address = false
  tags = {
    Name       = "CompliantEC2"
    Compliance = "CIS_NIST"
  }
}

resource "aws_config_config_rule" "ec2_no_public_ip" {
  name = "ec2-instance-no-public-ip"
  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"
  }
}
