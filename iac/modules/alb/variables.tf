variable "alb_name" {
  description = "Nombre del Application Load Balancer"
  type        = string
  default     = "app-alb"
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "IDs de las subnets públicas"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "IDs de los security groups"
  type        = list(string)
  default     = []
}

variable "certificate_arn" {
  description = "ARN del certificado ACM"
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  description = "Habilitar protección contra eliminación"
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "Configuración de los target groups"
  type = map(object({
    name               = string
    port               = number
    health_check_path  = string
    path_patterns      = list(string)
    priority           = number
  }))
  default = {}
}

variable "tags" {
  description = "Tags para los recursos ALB"
  type        = map(string)
  default     = {}
}
