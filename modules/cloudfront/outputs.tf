output "distribution_id" {
  description = "CloudFront distribution ID."
  value       = aws_cloudfront_distribution.this.id
}
output "distribution_arn" {
  description = "CloudFront distribution ARN."
  value       = aws_cloudfront_distribution.this.arn
}
output "domain_name" {
  description = "CloudFront distribution domain name."
  value       = aws_cloudfront_distribution.this.domain_name
}
output "origin_access_control_ids" {
  description = "OAC IDs keyed by S3 origin key."
  value = { for key, oac in aws_cloudfront_origin_access_control.this : key => oac.id
  }
}
