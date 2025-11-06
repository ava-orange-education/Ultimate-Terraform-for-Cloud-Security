resource "aws_db_instance" "db" {
  count = terraform.workspace == "prod" ? 1 : 0

  allocated_storage = terraform.workspace == "prod" ? 100 : 20
  engine            = "mysql"
  instance_class    = "db.t3.medium"
}
