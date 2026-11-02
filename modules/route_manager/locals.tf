locals {
  generated_name = "routes-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name           = trimspace(var.name) != "" ? trimspace(var.name) : local.generated_name

  effective_routes = {
    for key, route in var.routes : key => {
      route_table_id              = route.route_table_id
      destination_cidr_block      = try(route.destination_cidr_block, null)
      destination_ipv6_cidr_block = try(route.destination_ipv6_cidr_block, null)
      target = try(
        route.failover.active_target == "secondary" ? route.failover.secondary_target : route.target,
        route.target
      )
      active_target = try(route.failover.active_target, "primary")
      has_failover  = try(route.failover != null, false)
    }
  }
}
