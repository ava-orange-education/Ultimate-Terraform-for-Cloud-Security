resource "google_storage_bucket" "gdpr_bucket" {  
  name          = "gdpr-sensitive-data"  
  location      = "EU"  
  force_destroy = true  

  encryption {  
    default_kms_key_name = google_kms_crypto_key.gdpr_key.id  
  }  
}  

resource "google_kms_crypto_key" "gdpr_key" {  
  name     = "gdpr-encryption-key"  
  key_ring = google_kms_key_ring.gdpr_ring.id  
  purpose  = "ENCRYPT_DECRYPT"  
}  
