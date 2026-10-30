output "event_bus_name" {
  description = "Event bus name."
  value       = local.create_bus ? aws_cloudwatch_event_bus.this[0].name : "default"
}
output "event_bus_arn" {
  description = "Custom event bus ARN, or null."
  value       = try(aws_cloudwatch_event_bus.this[0].arn, null)
}
output "rule_arns" {
  description = "Rule ARNs keyed by input key."
  value       = { for k, v in aws_cloudwatch_event_rule.this : k => v.arn }
}
output "archive_arn" {
  description = "Archive ARN when created."
  value       = try(aws_cloudwatch_event_archive.this[0].arn, null)
}
output "tags" {
  description = "Effective tags."
  value       = local.tags
}
