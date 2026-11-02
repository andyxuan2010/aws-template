resource "aws_ec2_transit_gateway" "this" {
  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  tags                            = local.transit_gateway_tags

  lifecycle {
    precondition {
      condition     = length(var.attachments) > 0 && length(var.route_tables) > 0
      error_message = "At least one VPC attachment and one route table are required."
    }
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.attachments

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  dns_support                                     = each.value.dns_support
  ipv6_support                                    = each.value.ipv6_support
  appliance_mode_support                          = each.value.appliance_mode_support
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  tags                                            = local.attachment_tags[each.key]

  lifecycle {
    precondition {
      condition = (
        contains(keys(var.route_tables), each.value.route_table_key) &&
        alltrue([
          for route_table_key in each.value.propagated_route_table_keys :
          contains(keys(var.route_tables), route_table_key)
        ])
      )
      error_message = "route_table_key and propagated_route_table_keys must reference keys in route_tables."
    }
  }
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each = var.route_tables

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags               = local.route_table_tags[each.key]

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = var.attachments

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = try(
    aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id,
    null
  )

  lifecycle {
    precondition {
      condition     = contains(keys(var.route_tables), each.value.route_table_key)
      error_message = "Each attachment route_table_key must match a declared route_tables key."
    }
  }
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = local.propagations

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.this[each.value.attachment_key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[
    each.value.route_table_key
  ].id
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = local.static_routes

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id
  destination_cidr_block         = each.value.destination_cidr_block
  transit_gateway_attachment_id = try(
    aws_ec2_transit_gateway_vpc_attachment.this[each.value.attachment_key].id,
    null
  )

  lifecycle {
    precondition {
      condition     = contains(keys(var.attachments), each.value.attachment_key)
      error_message = "Each static route attachment_key must match a declared attachments key."
    }
  }
}
