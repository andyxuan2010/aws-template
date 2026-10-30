output "log_group_arns" {
  description = "Log group ARNs keyed by input key."
  value       = { for k, v in aws_cloudwatch_log_group.this : k => v.arn }
}
output "alarm_arns" {
  description = "Alarm ARNs keyed by input key."
  value       = { for k, v in aws_cloudwatch_metric_alarm.this : k => v.arn }
}
output "dashboard_arn" {
  description = "Dashboard ARN when created."
  value       = try(aws_cloudwatch_dashboard.this[0].dashboard_arn, null)
}
output "tags" {
  description = "Effective base tags."
  value       = local.tags
}
