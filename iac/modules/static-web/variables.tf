variable "domain_name" {
  description = "Nombre del dominio para el sitio web estático"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]\\.[a-z]{2,}$", var.domain_name))
    error_message = "El nombre del dominio debe ser válido"
  }
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser dev, staging o prod"
  }
}

variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
  default     = ""
}

variable "cloudfront_price_class" {
  description = "Clase de precio de CloudFront"
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.cloudfront_price_class)
    error_message = "La clase de precio debe ser válida"
  }
}

variable "cache_min_ttl" {
  description = "TTL mínimo de cache en segundos"
  type        = number
  default     = 0
}

variable "cache_default_ttl" {
  description = "TTL por defecto de cache en segundos"
  type        = number
  default     = 3600
}

variable "cache_max_ttl" {
  description = "TTL máximo de cache en segundos"
  type        = number
  default     = 86400
}

variable "enable_logging" {
  description = "Habilitar logging de CloudFront"
  type        = bool
  default     = true
}

variable "logs_retention_days" {
  description = "Días de retención de logs"
  type        = number
  default     = 90
}

variable "common_tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default     = {}
}
