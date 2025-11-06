package example.ec2  
deny[msg] {
  input.resource_changes[_].type == "aws_instance"
  input.resource_changes[_].change.after.ami_id != "ami-12345678"
  msg = "Only approved AMIs are allowed"
}
