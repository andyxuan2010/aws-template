resource "aws_ecs_task_definition" "this" {
  family                   = local.name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions    = var.container_definitions_json
  tags                     = local.tags

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_gib == null ? [] : [var.ephemeral_storage_gib]
    content {
      size_in_gib = ephemeral_storage.value
    }
  }
}

resource "aws_ecs_service" "this" {
  name                               = local.name
  cluster                            = var.cluster_arn
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  platform_version                   = var.platform_version
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = length(var.load_balancers) > 0 ? var.health_check_grace_period_seconds : null
  enable_execute_command             = var.enable_execute_command
  wait_for_steady_state              = var.wait_for_steady_state
  propagate_tags                     = "SERVICE"
  enable_ecs_managed_tags            = true
  tags                               = local.tags

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  deployment_circuit_breaker {
    enable   = var.enable_deployment_circuit_breaker
    rollback = var.enable_deployment_circuit_breaker ? var.rollback_on_deployment_failure : false
  }

  dynamic "load_balancer" {
    for_each = var.load_balancers
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registry_arn == null ? [] : [var.service_registry_arn]
    content {
      registry_arn = service_registries.value
    }
  }

  lifecycle {
    precondition {
      condition     = !var.assign_public_ip
      error_message = "Public task IPs are prohibited; use private subnets and controlled ingress/egress."
    }

    precondition {
      condition     = var.enable_deployment_circuit_breaker
      error_message = "The ECS deployment circuit breaker is mandatory."
    }

    precondition {
      condition     = var.environment != "prod" || var.desired_count >= 2
      error_message = "Production services require at least two desired tasks."
    }
  }
}
