output "detector_id" {
  description = "GuardDuty detector ID for the provider's configured Region."
  value       = aws_guardduty_detector.this.id
}

output "detector_arn" {
  description = "GuardDuty detector ARN."
  value       = aws_guardduty_detector.this.arn
}

output "account_id" {
  description = "AWS account ID that owns the detector."
  value       = aws_guardduty_detector.this.account_id
}

output "feature_statuses" {
  description = "Configured feature statuses keyed by AWS feature name."
  value       = { for name, feature in var.features : name => feature.status }
}
