package aws.s3  
default allow = false  
allow {  
  input.resource.type == "aws_s3_bucket"  
  input.resource.encryption == "AES256"  
}
