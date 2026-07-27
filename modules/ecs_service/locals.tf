locals {
  generated_name = "ecs-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name           = var.name != "" ? var.name : local.generated_name
  tags           = merge(var.inherited_tags, var.tags, { Name = local.name })
}
