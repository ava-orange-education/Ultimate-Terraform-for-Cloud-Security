resource "aws_s3_bucket" "soc2_data" {  
  bucket = "soc2-sensitive-data"  
  acl    = "private"  

  server_side_encryption_configuration {  
    rule {  
      apply_server_side_encryption_by_default {  
        sse_algorithm = "aws:kms"  
        kms_master_key_id = "alias/soc2-key"  
      }  
    }  
  }  
}  

resource "aws_cloudtrail" "soc2_trail" {  
  name                          = "soc2-cloudtrail"  
  s3_bucket_name                = aws_s3_bucket.soc2_data.id  
  include_global_service_events = true  
}  
