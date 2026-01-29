resource "aws_db_subnet_group" "main" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = var.security_group_ids
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  storage_encrypted       = true
  kms_key_id              = var.kms_key_arn
  enabled_cloudwatch_logs_exports = ["postgresql"]
  tags = var.tags
}

resource "aws_rds_cluster_instance" "main" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.main.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.main.engine
  engine_version     = aws_rds_cluster.main.engine_version
  tags               = var.tags
}

resource "aws_appautoscaling_target" "aurora_replicas" {
  count              = var.autoscaling_enabled ? 1 : 0
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "cluster:${aws_rds_cluster.main.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "aurora_cpu" {
  count              = var.autoscaling_enabled ? 1 : 0
  name               = "${var.cluster_identifier}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.aurora_replicas[0].resource_id
  scalable_dimension = aws_appautoscaling_target.aurora_replicas[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.aurora_replicas[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }
    target_value       = var.autoscaling_target_cpu
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "aurora_connections" {
  count              = var.autoscaling_enabled ? 1 : 0
  name               = "${var.cluster_identifier}-connections-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.aurora_replicas[0].resource_id
  scalable_dimension = aws_appautoscaling_target.aurora_replicas[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.aurora_replicas[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageDatabaseConnections"
    }
    target_value       = var.autoscaling_target_connections
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}
