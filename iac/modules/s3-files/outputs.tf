output "bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.files.id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.files.arn
}

output "bucket_domain_name" {
  description = "Domain name del bucket"
  value       = aws_s3_bucket.files.bucket_domain_name
}
