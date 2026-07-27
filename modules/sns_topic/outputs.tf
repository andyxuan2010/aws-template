output "topic_arn" {
  description = "SNS topic ARN."
  value       = aws_sns_topic.this.arn
}

output "topic_name" {
  description = "Resolved topic name."
  value       = aws_sns_topic.this.name
}

output "subscription_arns" {
  description = "Subscription ARNs keyed by logical name."
  value       = { for key, subscription in aws_sns_topic_subscription.this : key => subscription.arn }
}

output "subscription_ids" {
  description = "Subscription IDs keyed by logical name."
  value       = { for key, subscription in aws_sns_topic_subscription.this : key => subscription.id }
}
