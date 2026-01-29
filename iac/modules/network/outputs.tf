output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block de la VPC"
  value       = aws_vpc.main.cidr_block
}

output "storage_subnet_ids" {
  description = "Lista de IDs de las subnets privadas de storage"
  value       = aws_subnet.storage_private[*].id
}

output "storage_subnet_cidrs" {
  description = "Lista de CIDR blocks de las subnets de storage"
  value       = aws_subnet.storage_private[*].cidr_block
}

output "compute_subnet_ids" {
  description = "Lista de IDs de las subnets privadas de cómputo"
  value       = aws_subnet.compute_private[*].id
}

output "compute_subnet_cidrs" {
  description = "Lista de CIDR blocks de las subnets de cómputo"
  value       = aws_subnet.compute_private[*].cidr_block
}

output "public_subnet_ids" {
  description = "Lista de IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "Lista de CIDR blocks de las subnets públicas"
  value       = aws_subnet.public[*].cidr_block
}

output "availability_zones" {
  description = "Lista de Availability Zones utilizadas"
  value       = data.aws_availability_zones.available.names
}

output "private_route_table_id" {
  description = "ID de la route table privada"
  value       = aws_route_table.private.id
}

output "public_route_table_id" {
  description = "ID de la route table pública"
  value       = aws_route_table.public.id
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.main.id
}
