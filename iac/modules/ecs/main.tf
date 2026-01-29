resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.cluster_name}-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_execution_custom" {
  name = "${var.cluster_name}-task-execution-custom"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = var.secrets_arns
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = var.kms_key_arns
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.cluster_name}-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "ecs_task_permissions" {
  name = "${var.cluster_name}-task-permissions"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ]
          Resource = var.secrets_arns
        },
        {
          Effect = "Allow"
          Action = [
            "kms:Decrypt",
            "kms:DescribeKey"
          ]
          Resource = var.kms_key_arns
        }
      ],
      var.dynamodb_table_arns != null ? [{
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = var.dynamodb_table_arns
      }] : [],
      var.s3_bucket_arns != null ? [{
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = flatten([
          var.s3_bucket_arns,
          [for arn in var.s3_bucket_arns : "${arn}/*"]
        ])
      }] : []
    )
  })
}

resource "aws_ecs_task_definition" "services" {
  for_each = var.services

  family                   = each.value.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([{
    name      = each.value.name
    image     = each.value.image
    essential = true
    portMappings = [{
      containerPort = each.value.container_port
      protocol      = "tcp"
    }]
    environment = [
      for k, v in each.value.environment : {
        name  = k
        value = v
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.cluster_name}/${each.value.name}"
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "services" {
  for_each = var.services

  name              = "/ecs/${var.cluster_name}/${each.value.name}"
  retention_in_days = 7
  tags              = var.tags
}

resource "aws_ecs_service" "services" {
  for_each = var.services

  name            = each.value.name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.services[each.key].arn
  desired_count   = each.value.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arns[each.key]
    container_name   = each.value.name
    container_port   = each.value.container_port
  }

  depends_on = [aws_iam_role_policy.ecs_task_permissions]

  tags = var.tags
}

resource "aws_appautoscaling_target" "ecs_services" {
  for_each = {
    for k, v in var.services : k => v
    if v.autoscaling != null
  }

  max_capacity       = each.value.autoscaling.max_capacity
  min_capacity       = each.value.autoscaling.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.services[each.key].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.services]
}

resource "aws_appautoscaling_policy" "ecs_cpu" {
  for_each = {
    for k, v in var.services : k => v
    if v.autoscaling != null
  }

  name               = "${each.value.name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_services[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_services[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_services[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = each.value.autoscaling.target_cpu
    scale_in_cooldown  = each.value.autoscaling.scale_in_cooldown
    scale_out_cooldown = each.value.autoscaling.scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "ecs_memory" {
  for_each = {
    for k, v in var.services : k => v
    if v.autoscaling != null
  }

  name               = "${each.value.name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_services[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_services[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_services[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = each.value.autoscaling.target_memory
    scale_in_cooldown  = each.value.autoscaling.scale_in_cooldown
    scale_out_cooldown = each.value.autoscaling.scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "ecs_alb_requests" {
  for_each = {
    for k, v in var.services : k => v
    if v.autoscaling != null
  }

  name               = "${each.value.name}-alb-requests-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_services[each.key].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_services[each.key].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_services[each.key].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${split(":", var.target_group_arns[each.key])[5]}/${split(":", var.target_group_arns[each.key])[6]}"
    }
    target_value       = 1000
    scale_in_cooldown  = each.value.autoscaling.scale_in_cooldown
    scale_out_cooldown = each.value.autoscaling.scale_out_cooldown
  }
}
