# Provision a Virtual Private Cloud and Subnetwork
resource "google_compute_network" "vpc" {
  name = "recovery-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "recovery-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}

# Deploy a Compute Engine instance as part of the recovery environment
resource "google_compute_instance" "app_instance" {
  name         = "recovery-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }
}

# Provision a Cloud SQL instance for database recovery
resource "google_sql_database_instance" "db_instance" {
  name             = "recovery-sql-instance"
  region           = "us-central1"
  database_version = "POSTGRES_13"
  
  settings {
    tier = "db-f1-micro"
    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }
  }
}

# Create a database within the Cloud SQL instance
resource "google_sql_database" "db" {
  name      = "appdb"
  instance  = google_sql_database_instance.db_instance.name
  charset   = "utf8"
  collation = "utf8_general_ci"
}
