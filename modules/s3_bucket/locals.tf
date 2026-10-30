locals {
  generated_name = "s3-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name           = var.name != "" ? var.name : local.generated_name
  tags           = merge(var.inherited_tags, var.tags, { Name = local.name })
}
