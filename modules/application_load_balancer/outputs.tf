output "load_balancer_arn" {
  description = "ALB ARN."
  value       = aws_lb.this.arn
}

output "load_balancer_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics."
  value       = aws_lb.this.arn_suffix
}

output "dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "Route 53 canonical hosted zone ID."
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "Target group ARNs keyed by logical name."
  value       = { for key, group in aws_lb_target_group.this : key => group.arn }
}

output "listener_arns" {
  description = "Listener ARNs keyed by logical name."
  value       = { for key, listener in aws_lb_listener.this : key => listener.arn }
}

output "name" {
  description = "Resolved ALB name."
  value       = local.name
}
