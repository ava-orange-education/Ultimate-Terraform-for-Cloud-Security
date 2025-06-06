provider "google" {
  project = var.gcp_project
  region  = "us-central1"
}

# Create an Instance Template for stateless compute nodes
resource "google_compute_instance_template" "stateless_template" {
  name_prefix  = "stateless-instance"
  machine_type = "n1-standard-1"
  
  disks {
    boot       = true
    auto_delete = true
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interfaces {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    echo "Starting stateless application"
    # Initialize application, which connects to an external DB (e.g. Cloud SQL) for sessions.
  EOF
}

# Deploy a Managed Instance Group using the Instance Template
resource "google_compute_region_instance_group_manager" "stateless_group" {
  name               = "stateless-instance-group"
  region             = "us-central1"
  base_instance_name = "stateless-instance"
  instance_template  = google_compute_instance_template.stateless_template.self_link
  target_size        = 2
}

# Provision a Cloud SQL instance for external state storage (e.g., for session data)
resource "google_sql_database_instance" "stateful_db" {
  name             = "stateful-db"
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
resource "google_sql_database" "sessions_db" {
  name     = "sessions"
  instance = google_sql_database_instance.stateful_db.name
  charset  = "utf8"
  collation = "utf8_general_ci"
}
