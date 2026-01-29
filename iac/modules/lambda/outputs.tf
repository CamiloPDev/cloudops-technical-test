output "function_name" {
  description = "Nombre de la función Lambda"
  value       = aws_lambda_function.main.function_name
}

output "function_arn" {
  description = "ARN de la función Lambda"
  value       = aws_lambda_function.main.arn
}

output "invoke_arn" {
  description = "ARN de invocación de la función"
  value       = aws_lambda_function.main.invoke_arn
}

output "role_arn" {
  description = "ARN del rol IAM de la función"
  value       = aws_iam_role.lambda.arn
}
