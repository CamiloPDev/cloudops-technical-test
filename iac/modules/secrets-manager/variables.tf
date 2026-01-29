variable "secret_name" {
  description = "Nombre del secreto"
  type        = string
  default     = "app-secrets"
}

variable "description" {
  description = "Descripción del secreto"
  type        = string
  default     = "Application secrets"
}

variable "secret_data" {
  description = "Datos del secreto en formato map"
  type        = map(string)
  sensitive   = true
  default     = {
    username = "admin"
    password = "ChangeMe123456!"
  }
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para encriptación"
  type        = string
  default     = ""
}

variable "recovery_window_in_days" {
  description = "Días de recuperación antes de eliminar permanentemente"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags para el secreto"
  type        = map(string)
  default     = {}
}
