output "trail_name" {
  description = "Resolved CloudTrail name."
  value       = aws_cloudtrail.this.name
}

output "trail_arn" {
  description = "CloudTrail ARN."
  value       = aws_cloudtrail.this.arn
}

output "trail_home_region" {
  description = "Region where the CloudTrail resource is managed."
  value       = var.region
}

output "log_bucket_name" {
  description = "Name of the dedicated, encrypted S3 log bucket."
  value       = aws_s3_bucket.this.id
}

output "log_bucket_arn" {
  description = "ARN of the dedicated S3 log bucket."
  value       = aws_s3_bucket.this.arn
}
