locals {
  base_generated_name = "sqs-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  base_name           = var.name != "" ? trimsuffix(var.name, ".fifo") : local.base_generated_name
  name                = var.fifo_queue ? "${local.base_name}.fifo" : local.base_name
  tags                = merge(var.inherited_tags, var.tags, { Name = local.name })
}
