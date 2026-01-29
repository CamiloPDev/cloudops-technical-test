variable "description" {
  description = "Descripción de la clave KMS"
  type        = string
  default     = "KMS key for encryption"
}

variable "alias_name" {
  description = "Nombre del alias para la clave KMS"
  type        = string
  default     = "app-key"
}

variable "deletion_window_in_days" {
  description = "Días de espera antes de eliminar la clave"
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Habilitar rotación automática de la clave"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags para la clave KMS"
  type        = map(string)
  default     = {}
}
