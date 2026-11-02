locals {
  generated_name = substr("lambda-${var.workload}-${var.region_code}-${var.environment}-${var.instance}", 0, 64)
  name           = var.name != "" ? var.name : local.generated_name
  tags           = merge(var.inherited_tags, var.tags, { Name = local.name })
}
