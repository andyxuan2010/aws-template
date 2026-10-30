locals {
  name = var.name != "" ? var.name : "cache-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  tags = merge(var.inherited_tags, var.tags, { Name = local.name })
}
