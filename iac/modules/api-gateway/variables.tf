variable "api_name" {
  description = "Nombre del API Gateway"
  type        = string
  default     = "app-api"
}

variable "description" {
  description = "Descripción del API Gateway"
  type        = string
  default     = "API Gateway for application"
}

variable "stage_name" {
  description = "Nombre del stage"
  type        = string
  default     = "prod"
}

variable "log_retention_days" {
  description = "Días de retención de logs"
  type        = number
  default     = 7
}

variable "cors_allow_origins" {
  description = "Orígenes permitidos para CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_methods" {
  description = "Métodos permitidos para CORS"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "cors_allow_headers" {
  description = "Headers permitidos para CORS"
  type        = list(string)
  default     = ["*"]
}

variable "enable_lambda_integration" {
  description = "Habilitar integración con Lambda"
  type        = bool
  default     = false
}

variable "enable_alb_integration" {
  description = "Habilitar integración con ALB"
  type        = bool
  default     = false
}

variable "lambda_function_arn" {
  description = "ARN de la función Lambda"
  type        = string
  default     = ""
}

variable "lambda_function_name" {
  description = "Nombre de la función Lambda"
  type        = string
  default     = ""
}

variable "lambda_function_invoke_arn" {
  description = "ARN de invocación de la función Lambda"
  type        = string
  default     = ""
}

variable "alb_dns_name" {
  description = "DNS name del ALB público"
  type        = string
  default     = ""
}

variable "custom_domain_name" {
  description = "Nombre de dominio personalizado"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ARN del certificado ACM"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags para los recursos API Gateway"
  type        = map(string)
  default     = {}
}
