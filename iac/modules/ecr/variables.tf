variable "repository_name" {
  description = "Nombre del repositorio ECR"
  type        = string
  default     = "app-repo"
}

variable "image_tag_mutability" {
  description = "Mutabilidad de los tags de imagen"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Escanear imágenes al hacer push"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para encriptación"
  type        = string
  default     = ""
}

variable "max_image_count" {
  description = "Número máximo de imágenes a mantener"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags para el repositorio ECR"
  type        = map(string)
  default     = {}
}
