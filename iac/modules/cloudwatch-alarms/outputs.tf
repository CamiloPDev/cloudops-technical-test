output "alarm_arns" {
  description = "ARNs de todas las alarmas creadas"
  value = concat(
    aws_cloudwatch_metric_alarm.alb_unhealthy_hosts[*].arn,
    aws_cloudwatch_metric_alarm.alb_target_response_time[*].arn,
    aws_cloudwatch_metric_alarm.alb_5xx_errors[*].arn,
    [for alarm in aws_cloudwatch_metric_alarm.ecs_cpu_high : alarm.arn],
    [for alarm in aws_cloudwatch_metric_alarm.ecs_memory_high : alarm.arn],
    aws_cloudwatch_metric_alarm.lambda_errors[*].arn,
    aws_cloudwatch_metric_alarm.lambda_throttles[*].arn,
    aws_cloudwatch_metric_alarm.lambda_duration[*].arn,
    aws_cloudwatch_metric_alarm.aurora_cpu_high[*].arn,
    aws_cloudwatch_metric_alarm.aurora_connections_high[*].arn,
    aws_cloudwatch_metric_alarm.elasticache_cpu_high[*].arn,
    aws_cloudwatch_metric_alarm.elasticache_memory_high[*].arn,
    aws_cloudwatch_metric_alarm.dynamodb_user_errors[*].arn,
    aws_cloudwatch_metric_alarm.api_gateway_5xx_errors[*].arn,
    aws_cloudwatch_metric_alarm.api_gateway_latency[*].arn
  )
}

output "alarm_names" {
  description = "Nombres de todas las alarmas creadas"
  value = concat(
    aws_cloudwatch_metric_alarm.alb_unhealthy_hosts[*].alarm_name,
    aws_cloudwatch_metric_alarm.alb_target_response_time[*].alarm_name,
    aws_cloudwatch_metric_alarm.alb_5xx_errors[*].alarm_name,
    [for alarm in aws_cloudwatch_metric_alarm.ecs_cpu_high : alarm.alarm_name],
    [for alarm in aws_cloudwatch_metric_alarm.ecs_memory_high : alarm.alarm_name],
    aws_cloudwatch_metric_alarm.lambda_errors[*].alarm_name,
    aws_cloudwatch_metric_alarm.lambda_throttles[*].alarm_name,
    aws_cloudwatch_metric_alarm.lambda_duration[*].alarm_name,
    aws_cloudwatch_metric_alarm.aurora_cpu_high[*].alarm_name,
    aws_cloudwatch_metric_alarm.aurora_connections_high[*].alarm_name,
    aws_cloudwatch_metric_alarm.elasticache_cpu_high[*].alarm_name,
    aws_cloudwatch_metric_alarm.elasticache_memory_high[*].alarm_name,
    aws_cloudwatch_metric_alarm.dynamodb_user_errors[*].alarm_name,
    aws_cloudwatch_metric_alarm.api_gateway_5xx_errors[*].alarm_name,
    aws_cloudwatch_metric_alarm.api_gateway_latency[*].alarm_name
  )
}
