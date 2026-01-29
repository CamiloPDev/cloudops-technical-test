resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-main-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", { stat = "Sum", label = "ALB Requests" }],
            ["AWS/ApiGateway", "Count", { stat = "Sum", label = "API Gateway Requests" }],
            ["AWS/Lambda", "Invocations", { stat = "Sum", label = "Lambda Invocations" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "Request Overview"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", { stat = "Average", label = "ALB Latency" }],
            ["AWS/ApiGateway", "Latency", { stat = "Average", label = "API Gateway Latency" }],
            ["AWS/Lambda", "Duration", { stat = "Average", label = "Lambda Duration" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "Latency Overview (ms)"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", { stat = "Sum", label = "ALB 5XX" }],
            ["AWS/ApiGateway", "5XXError", { stat = "Sum", label = "API Gateway 5XX" }],
            ["AWS/Lambda", "Errors", { stat = "Sum", label = "Lambda Errors" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "Errors Overview"
          yAxis = {
            left = {
              min = 0
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", { stat = "Average", label = "Aurora CPU" }],
            ["AWS/ElastiCache", "CPUUtilization", { stat = "Average", label = "ElastiCache CPU" }],
            ["AWS/ECS", "CPUUtilization", { stat = "Average", label = "ECS CPU" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "CPU Utilization (%)"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "application" {
  dashboard_name = "${var.project_name}-application-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", { stat = "Sum", label = "Total Requests" }],
            [".", "HTTPCode_Target_2XX_Count", { stat = "Sum", label = "2XX Responses" }],
            [".", "HTTPCode_Target_4XX_Count", { stat = "Sum", label = "4XX Responses" }],
            [".", "HTTPCode_Target_5XX_Count", { stat = "Sum", label = "5XX Responses" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "ALB - Request Count by Status"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", { stat = "Average", label = "Average" }],
            ["AWS/ApplicationELB", "TargetResponseTime", { stat = "p95", label = "p95" }],
            ["AWS/ApplicationELB", "TargetResponseTime", { stat = "p99", label = "p99" }]
          ]
          period = 300
          region = var.region
          title  = "ALB - Response Time (seconds)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", { stat = "Sum", label = "Invocations" }],
            [".", "Errors", { stat = "Sum", label = "Errors" }],
            [".", "Throttles", { stat = "Sum", label = "Throttles" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "Lambda - Invocations & Errors"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", { stat = "Average", label = "Average" }],
            ["AWS/Lambda", "Duration", { stat = "p95", label = "p95" }],
            ["AWS/Lambda", "Duration", { stat = "p99", label = "p99" }]
          ]
          period = 300
          region = var.region
          title  = "Lambda - Duration (ms)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApiGateway", "Count", { stat = "Sum", label = "Requests" }],
            [".", "4XXError", { stat = "Sum", label = "4XX Errors" }],
            [".", "5XXError", { stat = "Sum", label = "5XX Errors" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "API Gateway - Requests & Errors"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApiGateway", "Latency", { stat = "Average", label = "Average" }],
            ["AWS/ApiGateway", "Latency", { stat = "p95", label = "p95" }],
            ["AWS/ApiGateway", "Latency", { stat = "p99", label = "p99" }]
          ]
          period = 300
          region = var.region
          title  = "API Gateway - Latency (ms)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", { stat = "Average", label = "Service1 CPU" }],
            [".", "MemoryUtilization", { stat = "Average", label = "Service1 Memory" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ECS Service1 - CPU & Memory (%)"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", { stat = "Average", label = "Service2 CPU" }],
            [".", "MemoryUtilization", { stat = "Average", label = "Service2 Memory" }]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ECS Service2 - CPU & Memory (%)"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "databases" {
  dashboard_name = "${var.project_name}-databases-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = var.aurora_cluster_id != "" ? [
            ["AWS/RDS", "CPUUtilization", { stat = "Average", label = "CPU", dimensions = { DBClusterIdentifier = var.aurora_cluster_id } }]
          ] : []
          period = 300
          stat   = "Average"
          region = var.region
          title  = "Aurora - CPU Utilization (%)"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = var.aurora_cluster_id != "" ? [
            ["AWS/RDS", "DatabaseConnections", { stat = "Average", label = "Connections", dimensions = { DBClusterIdentifier = var.aurora_cluster_id } }]
          ] : []
          period = 300
          stat   = "Average"
          region = var.region
          title  = "Aurora - Database Connections"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = var.aurora_cluster_id != "" ? [
            ["AWS/RDS", "ReadLatency", { stat = "Average", label = "Read Latency", dimensions = { DBClusterIdentifier = var.aurora_cluster_id } }],
            [".", "WriteLatency", { stat = "Average", label = "Write Latency", dimensions = { DBClusterIdentifier = var.aurora_cluster_id } }]
          ] : []
          period = 300
          stat   = "Average"
          region = var.region
          title  = "Aurora - Read/Write Latency (ms)"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = var.elasticache_replication_group_id != "" ? [
            ["AWS/ElastiCache", "CPUUtilization", { stat = "Average", label = "CPU", dimensions = { ReplicationGroupId = var.elasticache_replication_group_id } }]
          ] : []
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ElastiCache - CPU Utilization (%)"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = var.elasticache_replication_group_id != "" ? [
            ["AWS/ElastiCache", "DatabaseMemoryUsagePercentage", { stat = "Average", label = "Memory Usage", dimensions = { ReplicationGroupId = var.elasticache_replication_group_id } }]
          ] : []
          period = 300
          stat   = "Average"
          region = var.region
          title  = "ElastiCache - Memory Usage (%)"
          yAxis = {
            left = {
              min = 0
              max = 100
            }
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = var.elasticache_replication_group_id != "" ? [
            ["AWS/ElastiCache", "CacheHits", { stat = "Sum", label = "Cache Hits", dimensions = { ReplicationGroupId = var.elasticache_replication_group_id } }],
            [".", "CacheMisses", { stat = "Sum", label = "Cache Misses", dimensions = { ReplicationGroupId = var.elasticache_replication_group_id } }]
          ] : []
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "ElastiCache - Cache Hits vs Misses"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = var.dynamodb_table_name != "" ? [
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", { stat = "Sum", label = "Read Capacity", dimensions = { TableName = var.dynamodb_table_name } }],
            [".", "ConsumedWriteCapacityUnits", { stat = "Sum", label = "Write Capacity", dimensions = { TableName = var.dynamodb_table_name } }]
          ] : []
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "DynamoDB - Consumed Capacity Units"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = var.dynamodb_table_name != "" ? [
            ["AWS/DynamoDB", "UserErrors", { stat = "Sum", label = "User Errors", dimensions = { TableName = var.dynamodb_table_name } }],
            [".", "SystemErrors", { stat = "Sum", label = "System Errors", dimensions = { TableName = var.dynamodb_table_name } }]
          ] : []
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "DynamoDB - Errors"
        }
      }
    ]
  })
}
