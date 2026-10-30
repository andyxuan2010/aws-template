output "bucket_id" {
  description = "Bucket name."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Bucket ARN."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Bucket domain name."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional bucket domain name."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "name" {
  description = "Resolved bucket name."
  value       = local.name
}

output "object_lock_enabled" {
  description = "Whether Object Lock was enabled when the bucket was created."
  value       = var.object_lock.enabled
}
