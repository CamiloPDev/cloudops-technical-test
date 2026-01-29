variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
  default     = "app-table"
}

variable "billing_mode" {
  description = "Modo de facturación (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Atributo para usar como hash key"
  type        = string
  default     = "id"
}

variable "range_key" {
  description = "Atributo para usar como range key"
  type        = string
  default     = null
}

variable "attributes" {
  description = "Lista de atributos de la tabla"
  type = list(object({
    name = string
    type = string
  }))
  default = [
    {
      name = "id"
      type = "S"
    }
  ]
}

variable "global_secondary_indexes" {
  description = "Lista de índices secundarios globales"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = []
}

variable "read_capacity" {
  description = "Capacidad de lectura (solo para PROVISIONED)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Capacidad de escritura (solo para PROVISIONED)"
  type        = number
  default     = 5
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para encriptación"
  type        = string
  default     = ""
}

variable "enable_point_in_time_recovery" {
  description = "Habilitar recuperación point-in-time"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags para la tabla DynamoDB"
  type        = map(string)
  default     = {}
}
