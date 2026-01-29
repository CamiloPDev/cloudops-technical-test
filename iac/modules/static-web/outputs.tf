output "cloudfront_distribution_id" {
  description = "ID de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_distribution_arn" {
  description = "ARN de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.main.arn
}

output "cloudfront_domain_name" {
  description = "Nombre de dominio de CloudFront"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "website_url" {
  description = "URL del sitio web"
  value       = "https://${var.domain_name}"
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.main.id
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.main.arn
}

output "acm_certificate_arn" {
  description = "ARN del certificado ACM"
  value       = aws_acm_certificate.main.arn
}

output "route53_zone_id" {
  description = "ID de la zona Route 53"
  value       = aws_route53_zone.main.zone_id
}

output "route53_name_servers" {
  description = "Nameservers de Route 53"
  value       = aws_route53_zone.main.name_servers
}

output "logs_bucket_name" {
  description = "Nombre del bucket de logs"
  value       = var.enable_logging ? aws_s3_bucket.logs[0].id : null
}
