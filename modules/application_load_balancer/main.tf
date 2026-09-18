resource "aws_lb" "this" {
  name                       = local.name
  internal                   = var.internal
  load_balancer_type         = "application"
  security_groups            = var.security_group_ids
  subnets                    = var.subnet_ids
  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = var.drop_invalid_header_fields
  enable_http2               = var.enable_http2
  idle_timeout               = var.idle_timeout
  tags                       = local.tags

  dynamic "access_logs" {
    for_each = var.access_logs == null ? [] : [var.access_logs]
    content {
      enabled = true
      bucket  = access_logs.value.bucket
      prefix  = access_logs.value.prefix
    }
  }

  lifecycle {
    precondition {
      condition     = var.environment != "prod" || var.enable_deletion_protection
      error_message = "Production load balancers must enable deletion protection."
    }

    precondition {
      condition     = var.environment != "prod" || var.access_logs != null
      error_message = "Production load balancers must enable access logging."
    }
  }
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name                 = local.target_group_names[each.key]
  port                 = each.value.port
  protocol             = each.value.protocol
  protocol_version     = each.value.protocol_version
  target_type          = each.value.target_type
  vpc_id               = var.vpc_id
  deregistration_delay = each.value.deregistration_delay
  tags                 = merge(local.tags, each.value.tags, { Name = local.target_group_names[each.key] })

  health_check {
    enabled             = each.value.health_check.enabled
    path                = each.value.health_check.path
    port                = each.value.health_check.port
    protocol            = each.value.health_check.protocol
    matcher             = each.value.health_check.matcher
    interval            = each.value.health_check.interval
    timeout             = each.value.health_check.timeout
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
  }
}

resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  certificate_arn   = each.value.protocol == "HTTPS" ? each.value.certificate_arn : null
  ssl_policy        = each.value.protocol == "HTTPS" ? each.value.ssl_policy : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  dynamic "mutual_authentication" {
    for_each = each.value.protocol == "HTTPS" && each.value.mutual_authentication_mode != "off" ? [each.value] : []
    content {
      mode            = mutual_authentication.value.mutual_authentication_mode
      trust_store_arn = mutual_authentication.value.trust_store_arn
    }
  }

  lifecycle {
    precondition {
      condition     = each.value.protocol != "HTTP" || var.internal
      error_message = "Internet-facing listeners must use HTTPS."
    }
  }
}
