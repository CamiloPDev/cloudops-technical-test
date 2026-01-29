variable "function_name" {
  description = "Nombre de la función Lambda"
  type        = string
  default     = "app-lambda"
}

variable "filename" {
  description = "Ruta al archivo ZIP de la función"
  type        = string
  default     = "lambda_function.zip"
}

variable "handler" {
  description = "Handler de la función"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Runtime de la función"
  type        = string
  default     = "python3.11"
}

variable "timeout" {
  description = "Timeout en segundos"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Memoria en MB"
  type        = number
  default     = 128
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

variable "environment_variables" {
  description = "Variables de entorno"
  type        = map(string)
  default     = {}
}

variable "secrets_arns" {
  description = "ARNs de los secretos a los que puede acceder"
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
  description = "Tags para la función Lambda"
  type        = map(string)
  default     = {}
}
