output "key_id" {
  description = "ID de la clave KMS"
  value       = aws_kms_key.main.key_id
}

output "key_arn" {
  description = "ARN de la clave KMS"
  value       = aws_kms_key.main.arn
}

output "alias_arn" {
  description = "ARN del alias de la clave KMS"
  value       = aws_kms_alias.main.arn
}

output "alias_name" {
  description = "Nombre del alias de la clave KMS"
  value       = aws_kms_alias.main.name
}
