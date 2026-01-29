resource "aws_elasticache_subnet_group" "main" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = var.replication_group_id
  description                = var.description
  engine                     = "valkey"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_clusters
  parameter_group_name       = var.parameter_group_name
  port                       = var.port
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = var.security_group_ids
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = var.auth_token
  kms_key_id                 = var.kms_key_arn
  automatic_failover_enabled = var.num_cache_clusters > 1 ? true : false
  multi_az_enabled           = var.num_cache_clusters > 1 ? true : false
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window
  tags                       = var.tags
}
