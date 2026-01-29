output "cluster_id" {
  description = "ID del cluster Aurora"
  value       = aws_rds_cluster.main.id
}

output "cluster_arn" {
  description = "ARN del cluster Aurora"
  value       = aws_rds_cluster.main.arn
}

output "cluster_endpoint" {
  description = "Endpoint de escritura del cluster"
  value       = aws_rds_cluster.main.endpoint
}

output "cluster_reader_endpoint" {
  description = "Endpoint de lectura del cluster"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "cluster_port" {
  description = "Puerto del cluster"
  value       = aws_rds_cluster.main.port
}

output "database_name" {
  description = "Nombre de la base de datos"
  value       = aws_rds_cluster.main.database_name
}

output "autoscaling_target_id" {
  description = "ID del target de auto scaling"
  value       = var.autoscaling_enabled ? aws_appautoscaling_target.aurora_replicas[0].id : null
}

output "autoscaling_policy_arns" {
  description = "ARNs de las políticas de auto scaling"
  value = var.autoscaling_enabled ? {
    cpu         = aws_appautoscaling_policy.aurora_cpu[0].arn
    connections = aws_appautoscaling_policy.aurora_connections[0].arn
  } : null
}
