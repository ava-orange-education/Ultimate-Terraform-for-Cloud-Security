resource "aws_db_instance" "example" {
  allocated_storage        = 20
  storage_type             = "gp2"
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = "db.t3.medium"
  identifier               = "example-db"
  username                 = "admin"
  password                 = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.example.name
  vpc_security_group_ids    = [aws_security_group.db.id]
  multi_az                  = true         # Enables automated failover (low RTO)
  backup_retention_period   = 7            # Backups retained for 7 days (low RPO)
  preferred_backup_window   = "07:00-09:00"
  deletion_protection       = true         # Prevent accidental deletion
}
