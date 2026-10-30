locals {
  generated_name = "vpc-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name           = var.name != "" ? var.name : local.generated_name
  tags           = merge(var.inherited_tags, var.tags, { Name = local.name })

  public_subnets  = { for key, subnet in var.subnets : key => subnet if subnet.public }
  private_subnets = { for key, subnet in var.subnets : key => subnet if !subnet.public }
  public_subnet_keys_by_az = {
    for az in distinct([for subnet in values(local.public_subnets) : subnet.availability_zone]) :
    az => sort([for key, subnet in local.public_subnets : key if subnet.availability_zone == az])[0]
  }
  first_public_subnet_key = try(sort(keys(local.public_subnets))[0], null)
  nat_subnets = (
    var.nat_gateway_mode == "none" ? {} :
    var.nat_gateway_mode == "single" && local.first_public_subnet_key != null ? {
      (local.first_public_subnet_key) = local.public_subnets[local.first_public_subnet_key]
    } :
    { for key in values(local.public_subnet_keys_by_az) : key => local.public_subnets[key] }
  )
  nat_by_az      = { for key, subnet in local.nat_subnets : subnet.availability_zone => key }
  single_nat_key = try(sort(keys(local.nat_subnets))[0], null)
}
