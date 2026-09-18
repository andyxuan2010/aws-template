output "name" {
  description = "Resolved route manager name."
  value       = local.name
}

output "route_ids" {
  description = "Managed AWS route IDs keyed by stable logical route name."
  value       = { for key, route in aws_route.this : key => route.id }
}

output "route_table_ids" {
  description = "Route table IDs keyed by stable logical route name."
  value       = { for key, route in local.effective_routes : key => route.route_table_id }
}

output "active_targets" {
  description = "Effective active target type and ID keyed by stable logical route name."
  value       = { for key, route in local.effective_routes : key => route.target }
}

output "failover_enabled" {
  description = "Whether each managed route has a declarative secondary target."
  value       = { for key, route in local.effective_routes : key => route.has_failover }
}
