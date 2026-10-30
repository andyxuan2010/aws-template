output "account_id" {
  description = "AWS account ID with Security Hub CSPM enabled."
  value       = aws_securityhub_account.this.id
}
output "hub_arn" {
  description = "Security Hub CSPM hub ARN."
  value       = aws_securityhub_account.this.arn
}
output "standards_subscription_arns" {
  description = "Standards subscription ARNs keyed by standards ARN."
  value = { for arn, subscription in aws_securityhub_standards_subscription.this : arn => subscription.arn
  }
}
output "finding_aggregator_arn" {
  description = "Finding aggregator ARN when aggregation is enabled."
  value       = try(aws_securityhub_finding_aggregator.this[0].arn, null)
}
