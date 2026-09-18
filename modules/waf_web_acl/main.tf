resource "aws_wafv2_web_acl" "this" {
  name        = local.name
  scope       = upper(var.scope)
  description = "Managed by Terraform"
  tags        = local.tags
  dynamic "default_action" {
    for_each = upper(var.default_action) == "ALLOW" ? [1] : []
    content {
      allow {}
    }
  }
  dynamic "default_action" {
    for_each = upper(var.default_action) == "BLOCK" ? [1] : []
    content {
      block {}
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = local.name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }
  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name     = rule.key
      priority = rule.value.priority
      dynamic "override_action" {
        for_each = lower(rule.value.override_action) == "none" ? [1] : []
        content {
          none {}
        }
      }
      dynamic "override_action" {
        for_each = lower(rule.value.override_action) == "count" ? [1] : []
        content {
          count {}
        }
      }
      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = rule.value.vendor_name
          dynamic "rule_action_override" {
            for_each = rule.value.excluded_rules
            content {
              name = rule_action_override.value
              action_to_use {
                count {}
              }
            }
          }
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = "${local.name}-${rule.key}"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }
  dynamic "rule" {
    for_each = var.rate_based_rules
    content {
      name     = rule.key
      priority = rule.value.priority
      dynamic "action" {
        for_each = lower(rule.value.action) == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic "action" {
        for_each = lower(rule.value.action) == "count" ? [1] : []
        content {
          count {}
        }
      }
      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = rule.value.aggregate_key_type
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = "${local.name}-${rule.key}"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }
  lifecycle {
    precondition {
      condition     = upper(var.scope) == "REGIONAL" || length(var.resource_arns) == 0
      error_message = "CloudFront ACLs cannot use regional resource associations."
    }
  }
}
resource "aws_wafv2_web_acl_association" "this" {
  for_each     = var.resource_arns
  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
