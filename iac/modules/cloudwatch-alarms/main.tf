resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${var.project_name}-alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "ALB has unhealthy targets"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {
  alarm_name          = "${var.project_name}-alb-high-response-time"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "ALB target response time is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "${var.project_name}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "ALB is receiving too many 5xx errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  for_each            = var.ecs_service_names
  alarm_name          = "${var.project_name}-ecs-${each.key}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "ECS service ${each.key} CPU is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = each.value
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  for_each            = var.ecs_service_names
  alarm_name          = "${var.project_name}-ecs-${each.key}-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "ECS service ${each.key} memory is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = each.value
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.project_name}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Lambda function has errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  alarm_name          = "${var.project_name}-lambda-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Lambda function is being throttled"
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  alarm_name          = "${var.project_name}-lambda-high-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Average"
  threshold           = 10000
  alarm_description   = "Lambda function duration is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "aurora_cpu_high" {
  alarm_name          = "${var.project_name}-aurora-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Aurora CPU utilization is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.aurora_cluster_id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "aurora_connections_high" {
  alarm_name          = "${var.project_name}-aurora-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Aurora database connections are high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DBClusterIdentifier = var.aurora_cluster_id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "elasticache_cpu_high" {
  alarm_name          = "${var.project_name}-elasticache-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "ElastiCache CPU utilization is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = var.elasticache_replication_group_id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "elasticache_memory_high" {
  alarm_name          = "${var.project_name}-elasticache-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "ElastiCache memory usage is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = var.elasticache_replication_group_id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_user_errors" {
  alarm_name          = "${var.project_name}-dynamodb-user-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UserErrors"
  namespace           = "AWS/DynamoDB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "DynamoDB is receiving user errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    TableName = var.dynamodb_table_name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx_errors" {
  alarm_name          = "${var.project_name}-api-gateway-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "API Gateway is returning 5xx errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = var.api_gateway_name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_latency" {
  alarm_name          = "${var.project_name}-api-gateway-high-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Latency"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Average"
  threshold           = 1000
  alarm_description   = "API Gateway latency is high"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = var.api_gateway_name
  }

  tags = var.tags
}
