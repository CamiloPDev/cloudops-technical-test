variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "app"
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags para los security groups"
  type        = map(string)
  default     = {}
}
