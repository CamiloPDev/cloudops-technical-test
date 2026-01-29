output "replication_group_id" {
  description = "ID del grupo de replicación"
  value       = aws_elasticache_replication_group.main.id
}

output "primary_endpoint_address" {
  description = "Endpoint primario del cache"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Endpoint de lectura del cache"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "port" {
  description = "Puerto del cache"
  value       = aws_elasticache_replication_group.main.port
}
