output "transit_gateway_id" {
  description = "Transit gateway ID."
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "Transit gateway ARN."
  value       = aws_ec2_transit_gateway.this.arn
}

output "transit_gateway_name" {
  description = "Generated Transit Gateway Name tag."
  value       = local.transit_gateway_name
}

output "route_table_ids" {
  description = "Transit gateway route table IDs keyed by logical route table name."
  value       = { for key, route_table in aws_ec2_transit_gateway_route_table.this : key => route_table.id }
}

output "attachment_ids" {
  description = "VPC attachment IDs keyed by logical attachment name."
  value       = { for key, attachment in aws_ec2_transit_gateway_vpc_attachment.this : key => attachment.id }
}

output "route_ids" {
  description = "Static route IDs keyed by route table and route name."
  value       = { for key, route in aws_ec2_transit_gateway_route.this : key => route.id }
}
