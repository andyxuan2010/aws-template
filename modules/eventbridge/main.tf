resource "aws_cloudwatch_event_bus" "this" {
  count = local.create_bus ? 1 : 0
  name  = local.bus_name
  tags  = local.tags
}
resource "aws_cloudwatch_event_rule" "this" {
  for_each            = var.rules
  name                = "${local.bus_name}-${each.key}"
  description         = each.value.description
  event_bus_name      = local.create_bus ? aws_cloudwatch_event_bus.this[0].name : "default"
  event_pattern       = each.value.event_pattern
  schedule_expression = each.value.schedule_expression
  state               = each.value.state
  role_arn            = each.value.role_arn
  tags                = merge(local.tags, { Name = "${local.bus_name}-${each.key}" })
}
resource "aws_cloudwatch_event_target" "this" {
  for_each       = local.targets
  rule           = aws_cloudwatch_event_rule.this[each.value.rule_key].name
  event_bus_name = local.create_bus ? aws_cloudwatch_event_bus.this[0].name : "default"
  target_id      = each.value.target_key
  arn            = each.value.arn
  role_arn       = each.value.role_arn
  input          = each.value.input
  input_path     = each.value.input_path
  dynamic "dead_letter_config" {
    for_each = each.value.dead_letter_arn == null ? [] : [each.value.dead_letter_arn]
    content {
      arn = dead_letter_config.value
    }
  }
  dynamic "retry_policy" {
    for_each = each.value.retry_policy == null ? [] : [each.value.retry_policy]
    content {
      maximum_event_age_in_seconds = retry_policy.value.maximum_event_age_in_seconds
      maximum_retry_attempts       = retry_policy.value.maximum_retry_attempts
    }
  }
}
resource "aws_cloudwatch_event_archive" "this" {
  count            = var.archive == null ? 0 : 1
  name             = "${local.bus_name}-archive"
  event_source_arn = aws_cloudwatch_event_bus.this[0].arn
  retention_days   = var.archive.retention_days
  event_pattern    = var.archive.event_pattern
  lifecycle {
    precondition {
      condition     = local.create_bus
      error_message = "Archives require a custom event bus."
    }
  }
}
