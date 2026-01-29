output "cluster_id" {
  description = "ID del cluster ECS"
  value       = aws_ecs_cluster.main.id
}

output "cluster_arn" {
  description = "ARN del cluster ECS"
  value       = aws_ecs_cluster.main.arn
}

output "cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "task_execution_role_arn" {
  description = "ARN del rol de ejecución de tareas"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "task_role_arn" {
  description = "ARN del rol de tareas"
  value       = aws_iam_role.ecs_task.arn
}

output "service_names" {
  description = "Nombres de los servicios ECS"
  value       = [for s in aws_ecs_service.services : s.name]
}

output "autoscaling_target_ids" {
  description = "IDs de los targets de auto scaling"
  value       = { for k, v in aws_appautoscaling_target.ecs_services : k => v.id }
}

output "autoscaling_policy_arns" {
  description = "ARNs de las políticas de auto scaling"
  value = {
    cpu     = { for k, v in aws_appautoscaling_policy.ecs_cpu : k => v.arn }
    memory  = { for k, v in aws_appautoscaling_policy.ecs_memory : k => v.arn }
    requests = { for k, v in aws_appautoscaling_policy.ecs_alb_requests : k => v.arn }
  }
}
