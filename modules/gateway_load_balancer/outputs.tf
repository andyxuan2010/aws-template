output "name" {
  description = "Resolved Gateway Load Balancer name."
  value       = local.name
}

output "load_balancer_arn" {
  description = "Gateway Load Balancer ARN."
  value       = aws_lb.this.arn
}

output "load_balancer_arn_suffix" {
  description = "Gateway Load Balancer ARN suffix for CloudWatch metrics."
  value       = aws_lb.this.arn_suffix
}

output "dns_name" {
  description = "Gateway Load Balancer DNS name."
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "Route 53 canonical hosted zone ID."
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  description = "GENEVE target group ARN."
  value       = aws_lb_target_group.this.arn
}

output "target_group_arn_suffix" {
  description = "GENEVE target group ARN suffix for CloudWatch metrics."
  value       = aws_lb_target_group.this.arn_suffix
}

output "listener_arn" {
  description = "Gateway Load Balancer listener ARN."
  value       = aws_lb_listener.this.arn
}

output "target_attachment_ids" {
  description = "Target registration IDs keyed by the stable target input key."
  value       = { for key, attachment in aws_lb_target_group_attachment.this : key => attachment.id }
}

output "availability_zones" {
  description = "Availability Zones enabled on the Gateway Load Balancer."
  value       = local.availability_zones
}
