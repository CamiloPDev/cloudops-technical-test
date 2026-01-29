variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "app"
}

variable "alb_arn" {
  description = "ARN del ALB"
  type        = string
  default     = ""
}

variable "alb_arn_suffix" {
  description = "Sufijo del ARN del ALB"
  type        = string
  default     = ""
}

variable "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  type        = string
  default     = ""
}

variable "ecs_service_names" {
  description = "Mapa de nombres de servicios ECS"
  type        = map(string)
  default     = {}
}

variable "lambda_function_name" {
  description = "Nombre de la función Lambda"
  type        = string
  default     = ""
}

variable "aurora_cluster_id" {
  description = "ID del cluster Aurora"
  type        = string
  default     = ""
}

variable "elasticache_replication_group_id" {
  description = "ID del grupo de replicación de ElastiCache"
  type        = string
  default     = ""
}

variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
  default     = ""
}

variable "api_gateway_name" {
  description = "Nombre del API Gateway"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags para las alarmas"
  type        = map(string)
  default     = {}
}
