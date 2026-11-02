# Copyright (c) CCOE-Azure.
# SPDX-License-Identifier: Proprietary
#
# Module: route_manager
# Description: Manages AWS VPC routes for FortiGate ENI or GWLB endpoint
#              next hops, with an explicit declarative failover target switch.

resource "aws_route" "this" {
  for_each = local.effective_routes

  route_table_id              = each.value.route_table_id
  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block

  carrier_gateway_id        = null
  egress_only_gateway_id    = each.value.target.type == "egress_only_gateway_id" ? each.value.target.id : null
  gateway_id                = each.value.target.type == "gateway_id" ? each.value.target.id : null
  nat_gateway_id            = each.value.target.type == "nat_gateway_id" ? each.value.target.id : null
  network_interface_id      = each.value.target.type == "network_interface_id" ? each.value.target.id : null
  transit_gateway_id        = each.value.target.type == "transit_gateway_id" ? each.value.target.id : null
  vpc_endpoint_id           = each.value.target.type == "vpc_endpoint_id" ? each.value.target.id : null
  vpc_peering_connection_id = each.value.target.type == "vpc_peering_connection_id" ? each.value.target.id : null

  lifecycle {
    precondition {
      condition     = each.value.active_target == "primary" || each.value.active_target == "secondary"
      error_message = "active_target must be primary or secondary."
    }

    precondition {
      condition     = each.value.active_target != "secondary" || each.value.has_failover
      error_message = "active_target = secondary requires a failover.secondary_target definition."
    }
  }
}
