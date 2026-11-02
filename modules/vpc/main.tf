resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  instance_tenancy                 = var.instance_tenancy
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  tags                             = local.tags

  lifecycle {
    precondition {
      condition     = !var.enable_dns_hostnames || var.enable_dns_support
      error_message = "enable_dns_support must be true when enable_dns_hostnames is true."
    }

    precondition {
      condition     = var.nat_gateway_mode == "none" || var.enable_internet_gateway
      error_message = "enable_internet_gateway must be true when NAT gateways are requested."
    }

    precondition {
      condition     = var.nat_gateway_mode == "none" || length(local.public_subnets) > 0
      error_message = "At least one public subnet is required when NAT gateways are requested."
    }

    precondition {
      condition = var.nat_gateway_mode != "per_az" || alltrue([
        for subnet in values(local.private_subnets) :
        contains(keys(local.public_subnet_keys_by_az), subnet.availability_zone)
      ])
      error_message = "nat_gateway_mode per_az requires a public subnet in every Availability Zone containing a private subnet."
    }

    precondition {
      condition = !anytrue([
        for subnet in values(var.subnets) :
        subnet.ipv6_prefix_index != null || subnet.assign_ipv6_on_creation
      ]) || var.assign_generated_ipv6_cidr_block
      error_message = "assign_generated_ipv6_cidr_block must be true when a subnet requests IPv6."
    }
  }
}

resource "aws_internet_gateway" "this" {
  count  = var.enable_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "igw-${trimprefix(local.name, "vpc-")}" })
}

resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = each.value.ipv6_prefix_index == null ? null : cidrsubnet(aws_vpc.this.ipv6_cidr_block, 8, each.value.ipv6_prefix_index)
  availability_zone               = each.value.availability_zone
  map_public_ip_on_launch         = each.value.map_public_ip_on_launch
  assign_ipv6_address_on_creation = each.value.assign_ipv6_on_creation
  tags = merge(
    var.inherited_tags,
    var.tags,
    each.value.tags,
    { Name = "snet-${each.key}-${var.region_code}-${var.environment}-${var.instance}" }
  )
}

resource "aws_route_table" "public" {
  count  = length(local.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "rt-${var.workload}-public-${var.region_code}-${var.environment}-${var.instance}" })
}

resource "aws_route" "public_ipv4" {
  count = length(local.public_subnets) > 0 && var.enable_internet_gateway ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_eip" "nat" {
  for_each = local.nat_subnets

  domain = "vpc"
  tags   = merge(local.tags, { Name = "eip-${each.key}-${var.region_code}-${var.environment}-${var.instance}" })
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.this[each.key].id
  tags          = merge(local.tags, { Name = "nat-${each.key}-${var.region_code}-${var.environment}-${var.instance}" })

  depends_on = [aws_internet_gateway.this]

  lifecycle {
    precondition {
      condition     = var.enable_internet_gateway
      error_message = "enable_internet_gateway must be true when a NAT gateway is requested."
    }
  }
}

resource "aws_route_table" "private" {
  for_each = local.private_subnets

  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "rt-${each.key}-${var.region_code}-${var.environment}-${var.instance}" })
}

resource "aws_route" "private_nat" {
  for_each = {
    for key, subnet in local.private_subnets : key => subnet
    if var.nat_gateway_mode != "none"
  }

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this[
    var.nat_gateway_mode == "single" ? local.single_nat_key : local.nat_by_az[each.value.availability_zone]
  ].id
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_egress_only_internet_gateway" "this" {
  count  = var.assign_generated_ipv6_cidr_block ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(local.tags, { Name = "eigw-${trimprefix(local.name, "vpc-")}" })
}

resource "aws_route" "private_ipv6" {
  for_each = var.assign_generated_ipv6_cidr_block ? local.private_subnets : {}

  route_table_id              = aws_route_table.private[each.key].id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this[0].id
}

resource "aws_route" "public_ipv6" {
  count = var.assign_generated_ipv6_cidr_block && length(local.public_subnets) > 0 && var.enable_internet_gateway ? 1 : 0

  route_table_id              = aws_route_table.public[0].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this[0].id
}

resource "aws_flow_log" "this" {
  count = var.flow_log.enabled ? 1 : 0

  vpc_id                   = aws_vpc.this.id
  log_destination          = var.flow_log.destination_arn
  log_destination_type     = var.flow_log.destination_type
  iam_role_arn             = var.flow_log.destination_type == "cloud-watch-logs" ? var.flow_log.iam_role_arn : null
  traffic_type             = var.flow_log.traffic_type
  max_aggregation_interval = var.flow_log.max_aggregation_interval
  log_format               = var.flow_log.log_format
  tags                     = merge(local.tags, { Name = "fl-${trimprefix(local.name, "vpc-")}" })

  lifecycle {
    precondition {
      condition     = var.flow_log.destination_arn != null
      error_message = "flow_log.destination_arn is required when flow logging is enabled."
    }

    precondition {
      condition     = var.flow_log.destination_type != "cloud-watch-logs" || var.flow_log.iam_role_arn != null
      error_message = "flow_log.iam_role_arn is required for a CloudWatch Logs destination."
    }
  }
}
