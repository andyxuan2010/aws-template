# Copyright (c) CCOE-Azure.
# SPDX-License-Identifier: Proprietary
#
# Module: gateway_load_balancer
# Description: Deploys an AWS Gateway Load Balancer and registers FortiGate
#              IP targets using the GENEVE protocol.

resource "aws_lb" "this" {
  name                             = local.name
  load_balancer_type               = "gateway"
  ip_address_type                  = "ipv4"
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  tags                             = local.tags

  dynamic "subnet_mapping" {
    for_each = var.subnet_mappings

    content {
      subnet_id            = subnet_mapping.value.subnet_id
      private_ipv4_address = try(subnet_mapping.value.private_ipv4_address, null)
    }
  }

  lifecycle {
    precondition {
      condition     = var.environment != "prod" || var.enable_deletion_protection
      error_message = "Production Gateway Load Balancers must enable deletion protection."
    }

    precondition {
      condition     = var.environment != "prod" || length(local.availability_zones) >= 2
      error_message = "Production Gateway Load Balancers require subnets in at least two Availability Zones."
    }
  }
}

resource "aws_lb_target_group" "this" {
  name                 = local.target_group_name
  port                 = 6081
  protocol             = "GENEVE"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  tags                 = merge(local.tags, { Name = local.target_group_name })

  health_check {
    enabled             = var.health_check.enabled
    protocol            = var.health_check.protocol
    port                = var.health_check.port == null ? "traffic-port" : tostring(var.health_check.port)
    path                = contains(["HTTP", "HTTPS"], var.health_check.protocol) ? var.health_check.path : null
    matcher             = contains(["HTTP", "HTTPS"], var.health_check.protocol) ? var.health_check.matcher : null
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }

  dynamic "stickiness" {
    for_each = var.stickiness.enabled ? [var.stickiness] : []

    content {
      enabled = true
      type    = stickiness.value.type
    }
  }

  target_failover {
    on_deregistration = var.target_failover.on_deregistration
    on_unhealthy      = var.target_failover.on_unhealthy
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = var.targets

  target_group_arn  = aws_lb_target_group.this.arn
  target_id         = each.value.ip
  port              = 6081
  availability_zone = each.value.availability_zone
}
