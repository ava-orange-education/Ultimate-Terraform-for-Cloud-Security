resource "aws_secretsmanager_secret" "db_secret" {
  name        = "rds-rotation-secret"
  description = "RDS DB password secret"
}

resource "aws_secretsmanager_secret_rotation" "rotation" {
  secret_id           = aws_secretsmanager_secret.db_secret.id
  rotation_lambda_arn = aws_lambda_function.secret_rotation.arn
  rotation_rules {
    automatically_after_days = 30
  }
}
