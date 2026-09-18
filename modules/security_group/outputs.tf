output "security_group_id" {
  description = "Security group ID."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "Security group ARN."
  value       = aws_security_group.this.arn
}

output "name" {
  description = "Resolved security group name."
  value       = local.name
}

output "ingress_rule_ids" {
  description = "Ingress rule IDs keyed by logical rule name."
  value       = { for key, rule in aws_vpc_security_group_ingress_rule.this : key => rule.id }
}

output "egress_rule_ids" {
  description = "Egress rule IDs keyed by logical rule name."
  value       = { for key, rule in aws_vpc_security_group_egress_rule.this : key => rule.id }
}
