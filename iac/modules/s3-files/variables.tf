variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
  default     = "app-files"
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para encriptación"
  type        = string
  default     = ""
}

variable "enable_lifecycle" {
  description = "Habilitar políticas de lifecycle"
  type        = bool
  default     = true
}

variable "transition_to_ia_days" {
  description = "Días para transición a IA"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Días para transición a Glacier"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags para el bucket"
  type        = map(string)
  default     = {}
}
