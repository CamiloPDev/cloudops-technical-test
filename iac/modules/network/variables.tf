variable "project_name" {
  description = "Nombre del proyecto, usado para naming de recursos"
  type        = string

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 32
    error_message = "El nombre del proyecto debe tener entre 1 y 32 caracteres."
  }
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser dev, staging o prod."
  }
}

variable "region" {
  description = "Región AWS donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "El vpc_cidr debe ser un CIDR block válido en formato IPv4 (ejemplo: 10.0.0.0/16)."
  }
}

variable "storage_subnet_cidrs" {
  description = "Lista de CIDR blocks para las 3 subnets privadas de storage"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]

  validation {
    condition     = length(var.storage_subnet_cidrs) == 3
    error_message = "Debe proporcionar exactamente 3 CIDR blocks para storage subnets."
  }

  validation {
    condition     = alltrue([for cidr in var.storage_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Todos los CIDR blocks de storage deben ser válidos."
  }
}

variable "compute_subnet_cidrs" {
  description = "Lista de CIDR blocks para las 3 subnets privadas de cómputo"
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]

  validation {
    condition     = length(var.compute_subnet_cidrs) == 3
    error_message = "Debe proporcionar exactamente 3 CIDR blocks para compute subnets."
  }

  validation {
    condition     = alltrue([for cidr in var.compute_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Todos los CIDR blocks de compute deben ser válidos."
  }
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDR blocks para las subnets públicas (mínimo 2 para HA)"
  type        = list(string)
  default     = ["10.0.96.0/20", "10.0.112.0/20"]

  validation {
    condition     = length(var.public_subnet_cidrs) >= 2
    error_message = "Debe proporcionar al menos 2 CIDR blocks para subnets públicas (Alta Disponibilidad)."
  }

  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Todos los CIDR blocks públicos deben ser válidos."
  }
}

variable "common_tags" {
  description = "Tags comunes a aplicar a todos los recursos"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
