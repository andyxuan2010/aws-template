resource "aws_security_group" "this" {
  name                   = local.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = local.tags

  lifecycle {
    create_before_destroy = true

    precondition {
      condition = var.allow_public_ingress || alltrue([
        for rule in values(var.ingress_rules) :
        try(rule.cidr_ipv4, null) != "0.0.0.0/0" &&
        try(rule.cidr_ipv6, null) != "::/0"
      ])
      error_message = "Public ingress requires allow_public_ingress = true."
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.ingress_rules

  security_group_id            = aws_security_group.this.id
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  tags                         = merge(local.tags, { Name = "${local.name}-${each.key}-ingress" })
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.egress_rules

  security_group_id            = aws_security_group.this.id
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  tags                         = merge(local.tags, { Name = "${local.name}-${each.key}-egress" })
}
