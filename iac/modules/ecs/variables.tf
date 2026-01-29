variable "cluster_name" {
  description = "Nombre del cluster ECS"
  type        = string
  default     = "app-cluster"
}

variable "region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "subnet_ids" {
  description = "IDs de las subnets"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "IDs de los security groups"
  type        = list(string)
  default     = []
}

variable "services" {
  description = "Configuración de los servicios ECS"
  type = map(object({
    name           = string
    image          = string
    cpu            = string
    memory         = string
    container_port = number
    desired_count  = number
    environment    = map(string)
    autoscaling = optional(object({
      min_capacity       = number
      max_capacity       = number
      target_cpu         = number
      target_memory      = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    }))
  }))
  default = {}
}

variable "target_group_arns" {
  description = "ARNs de los target groups del ALB"
  type        = map(string)
  default     = {}
}

variable "secrets_arns" {
  description = "ARNs de los secretos"
  type        = list(string)
  default     = []
}

variable "kms_key_arns" {
  description = "ARNs de las claves KMS"
  type        = list(string)
  default     = []
}

variable "dynamodb_table_arns" {
  description = "ARNs de las tablas DynamoDB"
  type        = list(string)
  default     = null
}

variable "s3_bucket_arns" {
  description = "ARNs de los buckets S3"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags para los recursos ECS"
  type        = map(string)
  default     = {}
}
