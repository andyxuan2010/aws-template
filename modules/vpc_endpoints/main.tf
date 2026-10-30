resource "aws_vpc_endpoint" "this" {
  for_each = var.endpoints

  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  vpc_endpoint_type   = each.value.type
  subnet_ids          = each.value.type == "Interface" ? each.value.subnet_ids : null
  security_group_ids  = each.value.type == "Interface" ? each.value.security_group_ids : null
  route_table_ids     = each.value.type == "Gateway" ? each.value.route_table_ids : null
  private_dns_enabled = each.value.type == "Interface" ? each.value.private_dns_enabled : false
  policy              = each.value.policy
  tags = merge(
    var.inherited_tags,
    var.tags,
    each.value.tags,
    { Name = local.endpoint_names[each.key] }
  )

  lifecycle {
    precondition {
      condition = each.value.type == "Interface" ? (
        length(each.value.subnet_ids) > 0 &&
        length(each.value.security_group_ids) > 0 &&
        length(each.value.route_table_ids) == 0
        ) : (
        length(each.value.route_table_ids) > 0 &&
        length(each.value.subnet_ids) == 0 &&
        length(each.value.security_group_ids) == 0
      )
      error_message = "Interface endpoints require subnet_ids and security_group_ids and cannot set route_table_ids; Gateway endpoints require route_table_ids and cannot set subnet_ids or security_group_ids."
    }
  }
}
