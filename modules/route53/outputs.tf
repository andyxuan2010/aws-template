output "zone_id" {
  description = "Hosted zone ID."
  value       = aws_route53_zone.this.zone_id
}
output "zone_arn" {
  description = "Hosted zone ARN."
  value       = aws_route53_zone.this.arn
}
output "name_servers" {
  description = "Authoritative name servers for a public zone."
  value       = aws_route53_zone.this.name_servers
}
output "record_fqdns" {
  description = "Record FQDNs keyed by input key."
  value = { for key, record in aws_route53_record.this :
    key => record.fqdn
  }
}
output "tags" {
  description = "Effective hosted-zone tags."
  value       = local.tags
}
