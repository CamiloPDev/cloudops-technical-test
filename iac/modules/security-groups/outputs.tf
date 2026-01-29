output "lambda_sg_id" {
  description = "ID del security group de Lambda"
  value       = aws_security_group.lambda.id
}

output "ecs_sg_id" {
  description = "ID del security group de ECS"
  value       = aws_security_group.ecs.id
}

output "alb_sg_id" {
  description = "ID del security group de ALB"
  value       = aws_security_group.alb.id
}

output "aurora_sg_id" {
  description = "ID del security group de Aurora"
  value       = aws_security_group.aurora.id
}

output "elasticache_sg_id" {
  description = "ID del security group de ElastiCache"
  value       = aws_security_group.elasticache.id
}
