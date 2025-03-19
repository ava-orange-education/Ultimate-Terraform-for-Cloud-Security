#AWS S3 with KMS Integration
encrypt = true
kms_key_id = "alias/my-key"

#Azure Blob Storage with Customer Managed Keys
"encryption": {
  "keySource": "Microsoft.Keyvault"
}

#GCP Buckets with Default Encryption
"encryption": {
  "defaultKmsKeyName": "projects/my-project/locations/global/keyRings/my-key-ring/cryptoKeys/my-key"
}
