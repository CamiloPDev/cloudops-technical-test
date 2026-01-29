variable "cluster_identifier" {
  description = "Identificador del cluster Aurora"
  type        = string
  default     = "aurora-cluster"
}

variable "subnet_group_name" {
  description = "Nombre del subnet group"
  type        = string
  default     = "aurora-subnet-group"
}

variable "subnet_ids" {
  description = "IDs de las subnets para el cluster"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "IDs de los security groups"
  type        = list(string)
  default     = []
}

variable "engine_version" {
  description = "Versión del motor Aurora PostgreSQL"
  type        = string
  default     = "15.4"
}

variable "database_name" {
  description = "Nombre de la base de datos inicial"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Usuario maestro de la base de datos"
  type        = string
  default     = "postgres"
}

variable "master_password" {
  description = "Contraseña del usuario maestro"
  type        = string
  sensitive   = true
  default     = "ChangeMe123456!"
}

variable "instance_class" {
  description = "Clase de instancia para los nodos del cluster"
  type        = string
  default     = "db.t3.medium"
}

variable "instance_count" {
  description = "Número de instancias en el cluster (mínimo para auto scaling)"
  type        = number
  default     = 1
}

variable "autoscaling_enabled" {
  description = "Habilitar auto scaling para Aurora"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Capacidad mínima de réplicas para auto scaling"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Capacidad máxima de réplicas para auto scaling"
  type        = number
  default     = 5
}

variable "autoscaling_target_cpu" {
  description = "Objetivo de CPU para auto scaling (%)"
  type        = number
  default     = 70
}

variable "autoscaling_target_connections" {
  description = "Objetivo de conexiones para auto scaling"
  type        = number
  default     = 100
}

variable "autoscaling_scale_in_cooldown" {
  description = "Tiempo de espera antes de escalar hacia abajo (segundos)"
  type        = number
  default     = 300
}

variable "autoscaling_scale_out_cooldown" {
  description = "Tiempo de espera antes de escalar hacia arriba (segundos)"
  type        = number
  default     = 60
}

variable "backup_retention_period" {
  description = "Días de retención de backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Ventana de tiempo para backups"
  type        = string
  default     = "03:00-04:00"
}

variable "skip_final_snapshot" {
  description = "Omitir snapshot final al eliminar"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN de la clave KMS para encriptación"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags para los recursos Aurora"
  type        = map(string)
  default     = {}
}
