module "network" {
  source = "../../modules/network"

  project_name          = var.project_name
  environment           = var.environment
  region                = var.aws_region
  vpc_cidr              = var.vpc_cidr
  storage_subnet_cidrs  = var.storage_subnet_cidrs
  compute_subnet_cidrs  = var.compute_subnet_cidrs
  public_subnet_cidrs   = var.public_subnet_cidrs
  common_tags           = var.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  tags         = var.common_tags
}

module "kms" {
  source = "../../modules/kms"

  description             = "KMS key for ${var.project_name}"
  alias_name              = "${var.project_name}-key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.common_tags
}

module "secrets_manager" {
  source = "../../modules/secrets-manager"

  secret_name = "${var.project_name}-db-credentials"
  description = "Database credentials for ${var.project_name}"
  secret_data = {
    aurora_username      = var.aurora_master_username
    aurora_password      = var.aurora_master_password
    elasticache_token    = var.elasticache_auth_token
  }
  kms_key_arn = module.kms.key_arn
  tags        = var.common_tags
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  table_name  = "${var.project_name}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key    = "id"
  
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  kms_key_arn                    = module.kms.key_arn
  enable_point_in_time_recovery  = true
  tags                           = var.common_tags
}

module "aurora" {
  source = "../../modules/aurora"

  cluster_identifier      = "${var.project_name}-aurora"
  subnet_group_name       = "${var.project_name}-aurora-subnet-group"
  subnet_ids              = module.network.storage_subnet_ids
  security_group_ids      = [module.security_groups.aurora_sg_id]
  engine_version          = "15.4"
  database_name           = var.aurora_database_name
  master_username         = var.aurora_master_username
  master_password         = var.aurora_master_password
  instance_class          = var.aurora_instance_class
  instance_count          = 1
  backup_retention_period = 7
  skip_final_snapshot     = var.skip_final_snapshot
  kms_key_arn             = module.kms.key_arn
  
  autoscaling_enabled             = true
  autoscaling_min_capacity        = 1
  autoscaling_max_capacity        = 5
  autoscaling_target_cpu          = 70
  autoscaling_target_connections  = 100
  autoscaling_scale_in_cooldown   = 300
  autoscaling_scale_out_cooldown  = 60
  
  tags                    = var.common_tags
}

module "elasticache" {
  source = "../../modules/elasticache"

  replication_group_id     = "${var.project_name}-cache"
  description              = "ElastiCache for ${var.project_name}"
  subnet_group_name        = "${var.project_name}-cache-subnet-group"
  subnet_ids               = module.network.storage_subnet_ids
  security_group_ids       = [module.security_groups.elasticache_sg_id]
  engine_version           = "7.2"
  node_type                = var.elasticache_node_type
  num_cache_clusters       = 3
  auth_token               = var.elasticache_auth_token
  kms_key_arn              = module.kms.key_arn
  snapshot_retention_limit = 7
  tags                     = var.common_tags
}

module "s3_files" {
  source = "../../modules/s3-files"

  bucket_name                = "${var.project_name}-files-${var.environment}"
  kms_key_arn                = module.kms.key_arn
  enable_lifecycle           = true
  transition_to_ia_days      = 30
  transition_to_glacier_days = 90
  tags                       = var.common_tags
}

module "ecr_service1" {
  source = "../../modules/ecr"

  repository_name      = "${var.project_name}-service1"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  kms_key_arn          = module.kms.key_arn
  max_image_count      = 10
  tags                 = var.common_tags
}

module "ecr_service2" {
  source = "../../modules/ecr"

  repository_name      = "${var.project_name}-service2"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  kms_key_arn          = module.kms.key_arn
  max_image_count      = 10
  tags                 = var.common_tags
}

module "lambda" {
  source = "../../modules/lambda"

  function_name       = "${var.project_name}-function"
  filename            = "${path.module}/lambda_function.zip"
  handler             = "lambda_placeholder.handler"
  runtime             = "python3.11"
  timeout             = 30
  memory_size         = 256
  subnet_ids          = module.network.compute_subnet_ids
  security_group_ids  = [module.security_groups.lambda_sg_id]
  
  environment_variables = {
    DYNAMODB_TABLE      = module.dynamodb.table_name
    AURORA_ENDPOINT     = module.aurora.cluster_endpoint
    ELASTICACHE_ENDPOINT = module.elasticache.primary_endpoint_address
    SECRET_ARN          = module.secrets_manager.secret_arn
  }

  secrets_arns = [module.secrets_manager.secret_arn]
  kms_key_arns = [module.kms.key_arn]
  dynamodb_table_arns = [module.dynamodb.table_arn]
  s3_bucket_arns = [module.s3_files.bucket_arn]
  tags = var.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  cluster_name       = "${var.project_name}-cluster"
  region             = var.aws_region
  subnet_ids         = module.network.compute_subnet_ids
  security_group_ids = [module.security_groups.ecs_sg_id]

  services = {
    service1 = {
      name           = "${var.project_name}-service1"
      image          = "${module.ecr_service1.repository_url}:latest"
      cpu            = "256"
      memory         = "512"
      container_port = 8080
      desired_count  = 2
      environment = {
        DYNAMODB_TABLE       = module.dynamodb.table_name
        AURORA_ENDPOINT      = module.aurora.cluster_endpoint
        ELASTICACHE_ENDPOINT = module.elasticache.primary_endpoint_address
        SECRET_ARN           = module.secrets_manager.secret_arn
      }
      autoscaling = {
        min_capacity       = 2
        max_capacity       = 10
        target_cpu         = 70
        target_memory      = 80
        scale_in_cooldown  = 300
        scale_out_cooldown = 60
      }
    }
    service2 = {
      name           = "${var.project_name}-service2"
      image          = "${module.ecr_service2.repository_url}:latest"
      cpu            = "256"
      memory         = "512"
      container_port = 8080
      desired_count  = 2
      environment = {
        DYNAMODB_TABLE       = module.dynamodb.table_name
        AURORA_ENDPOINT      = module.aurora.cluster_endpoint
        ELASTICACHE_ENDPOINT = module.elasticache.primary_endpoint_address
        SECRET_ARN           = module.secrets_manager.secret_arn
      }
      autoscaling = {
        min_capacity       = 2
        max_capacity       = 10
        target_cpu         = 70
        target_memory      = 80
        scale_in_cooldown  = 300
        scale_out_cooldown = 60
      }
    }
  }

  target_group_arns = module.alb.target_group_arns

  secrets_arns        = [module.secrets_manager.secret_arn]
  kms_key_arns        = [module.kms.key_arn]
  dynamodb_table_arns = [module.dynamodb.table_arn]
  s3_bucket_arns      = [module.s3_files.bucket_arn]
  tags                = var.common_tags

  depends_on = [module.alb]
}

module "static_web" {
  source = "../../modules/static-web"

  domain_name = var.domain_name
  environment = var.environment

  bucket_name            = var.bucket_name
  cloudfront_price_class = var.cloudfront_price_class
  cache_min_ttl          = var.cache_min_ttl
  cache_default_ttl      = var.cache_default_ttl
  cache_max_ttl          = var.cache_max_ttl
  enable_logging         = var.enable_logging
  logs_retention_days    = var.logs_retention_days
  common_tags            = var.common_tags

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

resource "aws_acm_certificate" "api" {
  domain_name       = "api.${var.domain_name}"
  validation_method = "DNS"

  tags = merge(var.common_tags, {
    Name = "api.${var.domain_name}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "api_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = module.static_web.route53_zone_id
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api_cert_validation : record.fqdn]
}

module "alb" {
  source = "../../modules/alb"

  alb_name           = "${var.project_name}-alb"
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.public_subnet_ids
  security_group_ids = [module.security_groups.alb_sg_id]
  certificate_arn    = aws_acm_certificate_validation.api.certificate_arn

  target_groups = {
    service1 = {
      name              = "${var.project_name}-service1-tg"
      port              = 8080
      health_check_path = "/health"
      path_patterns     = ["/service1/*"]
      priority          = 100
    }
    service2 = {
      name              = "${var.project_name}-service2-tg"
      port              = 8080
      health_check_path = "/health"
      path_patterns     = ["/service2/*"]
      priority          = 200
    }
  }

  tags = var.common_tags
}

module "api_gateway" {
  source = "../../modules/api-gateway"

  api_name        = "${var.project_name}-api"
  description     = "API Gateway for ${var.project_name}"
  stage_name      = var.environment
  custom_domain_name = "api.${var.domain_name}"
  certificate_arn = aws_acm_certificate_validation.api.certificate_arn

  enable_lambda_integration  = true
  lambda_function_arn        = module.lambda.function_arn
  lambda_function_name       = module.lambda.function_name
  lambda_function_invoke_arn = module.lambda.invoke_arn

  enable_alb_integration = true
  alb_dns_name          = "https://${module.alb.alb_dns_name}"

  cors_allow_origins = ["https://${var.domain_name}", "https://www.${var.domain_name}"]

  tags = var.common_tags

  depends_on = [module.alb, module.lambda]
}

resource "aws_route53_record" "api" {
  zone_id = module.static_web.route53_zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.api_gateway.custom_domain_target
    zone_id                = module.api_gateway.custom_domain_hosted_zone_id
    evaluate_target_health = false
  }
}

module "cloudwatch_alarms" {
  source = "../../modules/cloudwatch-alarms"

  project_name                      = var.project_name
  alb_arn                          = module.alb.alb_arn
  alb_arn_suffix                   = module.alb.alb_arn_suffix
  ecs_cluster_name                 = module.ecs.cluster_name
  ecs_service_names                = {
    service1 = "${var.project_name}-service1"
    service2 = "${var.project_name}-service2"
  }
  lambda_function_name             = module.lambda.function_name
  aurora_cluster_id                = module.aurora.cluster_id
  elasticache_replication_group_id = module.elasticache.replication_group_id
  dynamodb_table_name              = module.dynamodb.table_name
  api_gateway_name                 = "${var.project_name}-api"
  tags                             = var.common_tags
}

module "cloudwatch_dashboards" {
  source = "../../modules/cloudwatch-dashboards"

  project_name                      = var.project_name
  region                           = var.aws_region
  alb_arn_suffix                   = module.alb.alb_arn_suffix
  ecs_cluster_name                 = module.ecs.cluster_name
  ecs_service_names                = {
    service1 = "${var.project_name}-service1"
    service2 = "${var.project_name}-service2"
  }
  lambda_function_name             = module.lambda.function_name
  aurora_cluster_id                = module.aurora.cluster_id
  elasticache_replication_group_id = module.elasticache.replication_group_id
  dynamodb_table_name              = module.dynamodb.table_name
  api_gateway_name                 = "${var.project_name}-api"
  cloudfront_distribution_id       = module.static_web.cloudfront_distribution_id
}
