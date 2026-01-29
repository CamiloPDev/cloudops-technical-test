output "website_url" {
  description = "URL del sitio web"
  value       = module.static_web.website_url
}

output "cloudfront_distribution_id" {
  description = "ID de la distribución de CloudFront"
  value       = module.static_web.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "Nombre de dominio de CloudFront"
  value       = module.static_web.cloudfront_domain_name
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = module.static_web.s3_bucket_name
}

output "route53_name_servers" {
  description = "Nameservers de Route 53 (configurar en el registrador de dominio)"
  value       = module.static_web.route53_name_servers
}

output "acm_certificate_arn" {
  description = "ARN del certificado ACM"
  value       = module.static_web.acm_certificate_arn
}

output "kms_key_id" {
  description = "ID de la clave KMS"
  value       = module.kms.key_id
}

output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = module.dynamodb.table_name
}

output "aurora_cluster_endpoint" {
  description = "Endpoint del cluster Aurora"
  value       = module.aurora.cluster_endpoint
}

output "aurora_reader_endpoint" {
  description = "Endpoint de lectura de Aurora"
  value       = module.aurora.cluster_reader_endpoint
}

output "elasticache_primary_endpoint" {
  description = "Endpoint primario de ElastiCache"
  value       = module.elasticache.primary_endpoint_address
}

output "elasticache_reader_endpoint" {
  description = "Endpoint de lectura de ElastiCache"
  value       = module.elasticache.reader_endpoint_address
}

output "s3_files_bucket_name" {
  description = "Nombre del bucket S3 de archivos"
  value       = module.s3_files.bucket_name
}

output "ecr_service1_url" {
  description = "URL del repositorio ECR service1"
  value       = module.ecr_service1.repository_url
}

output "ecr_service2_url" {
  description = "URL del repositorio ECR service2"
  value       = module.ecr_service2.repository_url
}

output "lambda_function_name" {
  description = "Nombre de la función Lambda"
  value       = module.lambda.function_name
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = module.ecs.cluster_name
}

output "secrets_manager_arn" {
  description = "ARN del secreto en Secrets Manager"
  value       = module.secrets_manager.secret_arn
  sensitive   = true
}

output "alb_dns_name" {
  description = "DNS name del Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "api_gateway_endpoint" {
  description = "Endpoint del API Gateway"
  value       = module.api_gateway.stage_invoke_url
}

output "api_custom_domain" {
  description = "Dominio personalizado del API"
  value       = "https://api.${var.domain_name}"
}

output "cloudwatch_dashboard_urls" {
  description = "URLs de los dashboards de CloudWatch"
  value       = module.cloudwatch_dashboards.dashboard_urls
}

output "cloudwatch_alarms_count" {
  description = "Número de alarmas de CloudWatch creadas"
  value       = length(module.cloudwatch_alarms.alarm_names)
}

output "logs_insights_queries" {
  description = "Queries predefinidas para CloudWatch Logs Insights"
  value       = module.cloudwatch_dashboards.logs_insights_queries
}
