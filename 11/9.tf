resource "aws_secretsmanager_secret" "db_password" {
  name = "db_password"
}

resource "random_password" "db_secret" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_secret.result
  })
}
