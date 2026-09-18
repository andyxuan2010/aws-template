output "web_acl_id" {
  description = "Web ACL ID."
  value       = aws_wafv2_web_acl.this.id
}
output "web_acl_arn" {
  description = "Web ACL ARN."
  value       = aws_wafv2_web_acl.this.arn
}
output "capacity" {
  description = "Web ACL capacity units."
  value       = aws_wafv2_web_acl.this.capacity
}
output "association_ids" {
  description = "Association IDs keyed by ARN."
  value       = { for k, v in aws_wafv2_web_acl_association.this : k => v.id }
}
output "tags" {
  description = "Effective tags."
  value       = local.tags
}
