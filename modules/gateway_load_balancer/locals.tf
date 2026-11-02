locals {
  generated_name    = substr("gwlb-${var.workload}-${var.region_code}-${var.environment}-${var.instance}", 0, 32)
  name              = trimspace(var.name) != "" ? trimspace(var.name) : local.generated_name
  target_group_name = trimspace(var.target_group_name) != "" ? trimspace(var.target_group_name) : substr("${local.name}-tg", 0, 32)

  availability_zones = distinct([for mapping in values(var.subnet_mappings) : mapping.availability_zone])

  tags = merge(
    var.inherited_tags,
    var.tags,
    {
      LoadBalancerType = "gateway"
      InspectionMode   = "geneve"
    }
  )
}
