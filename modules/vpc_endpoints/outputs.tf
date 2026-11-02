output "endpoint_ids" {
  description = "VPC endpoint IDs keyed by endpoint name."
  value       = { for key, endpoint in aws_vpc_endpoint.this : key => endpoint.id }
}

output "endpoint_arns" {
  description = "VPC endpoint ARNs keyed by endpoint name."
  value       = { for key, endpoint in aws_vpc_endpoint.this : key => endpoint.arn }
}

output "dns_entries" {
  description = "Interface endpoint DNS entries keyed by endpoint name. Gateway endpoints return empty lists."
  value       = { for key, endpoint in aws_vpc_endpoint.this : key => endpoint.dns_entry }
}

output "network_interface_ids" {
  description = "Interface endpoint network interface IDs keyed by endpoint name. Gateway endpoints return empty lists."
  value       = { for key, endpoint in aws_vpc_endpoint.this : key => endpoint.network_interface_ids }
}

output "prefix_list_ids" {
  description = "Gateway endpoint prefix list IDs keyed by endpoint name. Interface endpoints return null."
  value       = { for key, endpoint in aws_vpc_endpoint.this : key => endpoint.prefix_list_id }
}
