output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "VPC ARN."
  value       = aws_vpc.this.arn
}

output "name" {
  description = "Resolved VPC name."
  value       = local.name
}

output "subnet_ids" {
  description = "Subnet IDs keyed by logical subnet name."
  value       = { for key, subnet in aws_subnet.this : key => subnet.id }
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by logical subnet name."
  value       = { for key in keys(local.public_subnets) : key => aws_subnet.this[key].id }
}

output "private_subnet_ids" {
  description = "Private subnet IDs keyed by logical subnet name."
  value       = { for key in keys(local.private_subnets) : key => aws_subnet.this[key].id }
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs keyed by public subnet name."
  value       = { for key, gateway in aws_nat_gateway.this : key => gateway.id }
}

output "route_table_ids" {
  description = "Public and private route table IDs."
  value = {
    public  = try(aws_route_table.public[0].id, null)
    private = { for key, table in aws_route_table.private : key => table.id }
  }
}

output "flow_log_id" {
  description = "VPC Flow Log ID, or null when flow logging is disabled."
  value       = try(aws_flow_log.this[0].id, null)
}

output "ipv6_cidr_block" {
  description = "Amazon-provided VPC IPv6 CIDR, or null when IPv6 is disabled."
  value       = try(aws_vpc.this.ipv6_cidr_block, null)
}
