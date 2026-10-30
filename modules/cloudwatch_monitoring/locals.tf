locals {
  base_name = "mon-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  tags      = merge(var.inherited_tags, var.tags)
}
