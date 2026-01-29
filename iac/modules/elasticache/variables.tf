variable "replication_group_id" {
  description = "ID del grupo de replicación"
  type        = string
  default     = "elasticache-cluster"
}

variable "description" {
  description = "Descripción del grupo de replicación"
  type        = string
  default     = "ElastiCache replication group"
}

variable "subnet_group_name" {
  description = "Nombre del subnet group"
  type        = string
  default     = "elasticache-subnet-group"
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

variable "engine_version" {
  description = "Versión del motor Valkey"
  type        = string
  default     = "7.2"
}

variable "node_type" {
  description = "Tipo de nodo de cache"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_clusters" {
  description = "Número de nodos de cache"
  type        = number
  default     = 3
}

variable "parameter_group_name" {
  description = "Nombre del parameter group"
  type        = string
  default     = "default.valkey7"
}

variable "port" {
  description = "Puerto para el cache"
  type        = number
  default     = 6379
}

variable "auth_token" {
  description = "Token de autenticación"
  type        = string
  sensitive   = true
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para encriptación"
  type        = string
  default     = ""
}

variable "snapshot_retention_limit" {
  description = "Días de retención de snapshots"
  type        = number
  default     = 7
}

variable "snapshot_window" {
  description = "Ventana de tiempo para snapshots"
  type        = string
  default     = "03:00-05:00"
}

variable "tags" {
  description = "Tags para los recursos ElastiCache"
  type        = map(string)
  default     = {}
}
