locals {
  transit_gateway_name = "tgw-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  transit_gateway_tags = merge(var.inherited_tags, var.tags, { Name = local.transit_gateway_name })

  route_table_tags = {
    for key, route_table in var.route_tables : key => merge(
      var.inherited_tags,
      var.tags,
      route_table.tags,
      { Name = "tgw-rtb-${var.workload}-${key}-${var.region_code}-${var.environment}-${var.instance}" }
    )
  }

  attachment_tags = {
    for key, attachment in var.attachments : key => merge(
      var.inherited_tags,
      var.tags,
      attachment.tags,
      { Name = "tgw-attach-${var.workload}-${key}-${var.region_code}-${var.environment}-${var.instance}" }
    )
  }

  propagations = {
    for item in flatten([
      for route_table_key, route_table in var.route_tables : [
        for attachment_key in setintersection(
          toset([for key, attachment in var.attachments : key if contains(attachment.propagated_route_table_keys, route_table_key)]),
          toset(keys(var.attachments))
          ) : {
          key             = "${route_table_key}/${attachment_key}"
          route_table_key = route_table_key
          attachment_key  = attachment_key
        }
      ]
    ]) : item.key => item
  }

  static_routes = {
    for item in flatten([
      for route_table_key, route_table in var.route_tables : [
        for route_key, route in route_table.routes : {
          key                    = "${route_table_key}/${route_key}"
          route_table_key        = route_table_key
          destination_cidr_block = route.destination_cidr_block
          attachment_key         = route.attachment_key
        }
      ]
    ]) : item.key => item
  }
}
