output "dashboard_urls" {
  description = "URLs de los dashboards de CloudWatch"
  value = {
    main_dashboard     = "https://console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
    app_dashboard      = "https://console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.application.dashboard_name}"
    database_dashboard = "https://console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.databases.dashboard_name}"
  }
}

output "dashboard_names" {
  description = "Nombres de los dashboards creados"
  value = [
    aws_cloudwatch_dashboard.main.dashboard_name,
    aws_cloudwatch_dashboard.application.dashboard_name,
    aws_cloudwatch_dashboard.databases.dashboard_name
  ]
}

output "logs_insights_queries" {
  description = "Queries predefinidas para CloudWatch Logs Insights"
  value = {
    lambda_errors = "fields @timestamp, @message | filter @message like /ERROR/ | sort @timestamp desc | limit 100"
    api_gateway_latency = "fields @timestamp, status, latency | filter latency > 1000 | sort latency desc | limit 100"
    ecs_errors = "fields @timestamp, @message | filter @message like /error/ or @message like /exception/ | sort @timestamp desc | limit 100"
  }
}
