output "api_id" {
  description = "ID del API Gateway"
  value       = aws_apigatewayv2_api.main.id
}

output "api_endpoint" {
  description = "Endpoint del API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "api_execution_arn" {
  description = "ARN de ejecución del API Gateway"
  value       = aws_apigatewayv2_api.main.execution_arn
}

output "stage_invoke_url" {
  description = "URL de invocación del stage"
  value       = aws_apigatewayv2_stage.main.invoke_url
}

output "custom_domain_name" {
  description = "Nombre de dominio personalizado"
  value       = var.custom_domain_name != "" ? aws_apigatewayv2_domain_name.main[0].domain_name : ""
}

output "custom_domain_target" {
  description = "Target del dominio personalizado para Route53"
  value       = var.custom_domain_name != "" ? aws_apigatewayv2_domain_name.main[0].domain_name_configuration[0].target_domain_name : ""
}

output "custom_domain_hosted_zone_id" {
  description = "Hosted Zone ID del dominio personalizado"
  value       = var.custom_domain_name != "" ? aws_apigatewayv2_domain_name.main[0].domain_name_configuration[0].hosted_zone_id : ""
}
