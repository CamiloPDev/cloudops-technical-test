variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "cloudops-test"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "storage_subnet_cidrs" {
  description = "Lista de CIDR blocks para las 3 subnets privadas de storage"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
}

variable "compute_subnet_cidrs" {
  description = "Lista de CIDR blocks para las 3 subnets privadas de cómputo"
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDR blocks para las subnets públicas (mínimo 2 para HA)"
  type        = list(string)
  default     = ["10.0.96.0/20", "10.0.112.0/20"]
}

variable "domain_name" {
  description = "Nombre del dominio para el sitio web estático"
  type        = string
  default     = "example.com"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Nombre del bucket S3 (opcional)"
  type        = string
  default     = ""
}

variable "cloudfront_price_class" {
  description = "Clase de precio de CloudFront"
  type        = string
  default     = "PriceClass_100"
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

variable "aurora_database_name" {
  description = "Nombre de la base de datos Aurora"
  type        = string
  default     = "appdb"
}

variable "aurora_master_username" {
  description = "Usuario maestro de Aurora"
  type        = string
  default     = "dbadmin"
}

variable "aurora_master_password" {
  description = "Contraseña del usuario maestro de Aurora"
  type        = string
  sensitive   = true
  default     = "ChangeMe123456!"
}

variable "aurora_instance_class" {
  description = "Clase de instancia para Aurora"
  type        = string
  default     = "db.t3.medium"
}

variable "elasticache_node_type" {
  description = "Tipo de nodo para ElastiCache"
  type        = string
  default     = "cache.t3.micro"
}

variable "elasticache_auth_token" {
  description = "Token de autenticación para ElastiCache"
  type        = string
  sensitive   = true
  default     = "ChangeMe123456789012345678901234567890"
}

variable "skip_final_snapshot" {
  description = "Omitir snapshot final al eliminar Aurora"
  type        = bool
  default     = false
}
