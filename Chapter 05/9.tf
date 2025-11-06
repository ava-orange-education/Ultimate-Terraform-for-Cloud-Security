module "secure_gcs_bucket" {
  source             = "./modules/gcs_bucket"
  encryption_enabled = true
  versioning_enabled = true
}
