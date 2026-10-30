locals {
  generated_name            = "rds-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name                      = var.name != "" ? var.name : local.generated_name
  final_snapshot_identifier = "${local.name}-final"
  tags                      = merge(var.inherited_tags, var.tags, { Name = local.name })
}
