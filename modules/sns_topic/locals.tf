locals {
  base_generated_name = "sns-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  base_name           = var.name != "" ? trimsuffix(var.name, ".fifo") : local.base_generated_name
  name                = var.fifo_topic ? "${local.base_name}.fifo" : local.base_name
  tags                = merge(var.inherited_tags, var.tags, { Name = local.name })
}
