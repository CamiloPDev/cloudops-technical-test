locals {
  s3_origin_id = "S3-${var.domain_name}"
  bucket_name  = var.bucket_name != "" ? var.bucket_name : "${replace(var.domain_name, ".", "-")}-static-web"

  common_tags = merge(
    var.common_tags,
    {
      ManagedBy   = "Terraform"
      Module      = "static-web"
      Domain      = var.domain_name
      Environment = var.environment
    }
  )
}
