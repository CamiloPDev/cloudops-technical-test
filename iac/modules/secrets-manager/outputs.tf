output "secret_id" {
  description = "ID del secreto"
  value       = aws_secretsmanager_secret.main.id
}

output "secret_arn" {
  description = "ARN del secreto"
  value       = aws_secretsmanager_secret.main.arn
}

output "secret_name" {
  description = "Nombre del secreto"
  value       = aws_secretsmanager_secret.main.name
}
