resource "aws_cloudwatch_log_group" "this" {
  for_each          = var.log_groups
  name              = coalesce(each.value.name, "/${var.workload}/${var.environment}/${each.key}")
  retention_in_days = each.value.retention_in_days
  kms_key_id        = each.value.kms_key_id
  skip_destroy      = each.value.skip_destroy
  tags              = merge(local.tags, each.value.tags, { Name = coalesce(each.value.name, "/${var.workload}/${var.environment}/${each.key}") })
}
resource "aws_cloudwatch_metric_alarm" "this" {
  for_each            = var.metric_alarms
  alarm_name          = coalesce(each.value.alarm_name, "${local.base_name}-${each.key}")
  alarm_description   = each.value.description
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  threshold           = each.value.threshold
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  dimensions          = each.value.dimensions
  alarm_actions       = each.value.alarm_actions
  ok_actions          = each.value.ok_actions
  treat_missing_data  = each.value.treat_missing_data
  tags                = merge(local.tags, each.value.tags, { Name = coalesce(each.value.alarm_name, "${local.base_name}-${each.key}") })
}
resource "aws_cloudwatch_dashboard" "this" {
  count          = var.dashboard_body == null ? 0 : 1
  dashboard_name = local.base_name
  dashboard_body = var.dashboard_body
}
