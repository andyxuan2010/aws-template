resource "aws_route53_zone" "this" {
  name          = local.zone_name
  comment       = var.comment
  force_destroy = var.force_destroy
  tags          = local.tags
  dynamic "vpc" {
    for_each = var.private_zone ? var.vpc_associations : {}
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region

    }

  }
  lifecycle {
    precondition {
      condition     = !var.private_zone || length(var.vpc_associations) > 0
      error_message = "A private hosted zone requires at least one VPC association."

    }
    precondition {
      condition     = var.private_zone || length(var.vpc_associations) == 0
      error_message = "VPC associations are only valid for a private hosted zone."

    }

  }
}
resource "aws_route53_record" "this" {
  for_each        = var.records
  zone_id         = aws_route53_zone.this.zone_id
  name            = each.value.name
  type            = upper(each.value.type)
  ttl             = each.value.alias == null ? each.value.ttl : null
  records         = each.value.alias == null ? each.value.records : null
  allow_overwrite = each.value.allow_overwrite
  set_identifier  = each.value.set_identifier
  health_check_id = each.value.health_check_id
  dynamic "alias" {
    for_each = each.value.alias == null ? [] : [each.value.alias]
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health

    }

  }
  dynamic "weighted_routing_policy" {
    for_each = each.value.weighted_routing_policy == null ? [] : [each.value.weighted_routing_policy]
    content {
      weight = weighted_routing_policy.value.weight
    }

  }
}
