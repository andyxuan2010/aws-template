output "certificate_arn" {
  description = "Certificate ARN."
  value       = aws_acm_certificate.this.arn
}
output "domain_name" {
  description = "Normalized primary domain name."
  value       = local.domain_name
}
output "domain_validation_options" {
  description = "ACM domain validation options."
  value       = aws_acm_certificate.this.domain_validation_options
}
output "validation_record_fqdns" {
  description = "Created DNS validation record FQDNs."
  value       = [for record in aws_route53_record.validation : record.fqdn]
}
output "tags" {
  description = "Effective certificate tags."
  value       = local.tags
}
