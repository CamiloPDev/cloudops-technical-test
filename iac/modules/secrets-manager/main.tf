resource "aws_secretsmanager_secret" "main" {
  name                    = var.secret_name
  description             = var.description
  kms_key_id              = var.kms_key_arn
  recovery_window_in_days = var.recovery_window_in_days
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = jsonencode(var.secret_data)
}
