output "recorder_name" {
  description = "AWS Config recorder name."
  value       = aws_config_configuration_recorder.this.name
}

output "recorder_role_arn" {
  description = "IAM role ARN used by the AWS Config recorder."
  value       = aws_iam_role.this.arn
}

output "delivery_channel_name" {
  description = "AWS Config delivery channel name."
  value       = aws_config_delivery_channel.this.name
}

output "bucket_name" {
  description = "Name of the dedicated encrypted S3 bucket that stores configuration history and snapshots."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the dedicated AWS Config S3 bucket."
  value       = aws_s3_bucket.this.arn
}
