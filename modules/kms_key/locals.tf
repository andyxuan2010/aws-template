locals {
  generated_name = "kms-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name           = var.name != "" ? var.name : local.generated_name
  alias_name     = "alias/${local.name}"
  tags           = merge(var.inherited_tags, var.tags, { Name = local.name })
}
