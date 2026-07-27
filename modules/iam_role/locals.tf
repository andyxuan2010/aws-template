locals {
  generated_name        = "iam-${var.workload}-${var.environment}-${var.instance}"
  name                  = var.name != "" ? var.name : local.generated_name
  instance_profile_name = var.instance_profile_name != "" ? var.instance_profile_name : local.name
  tags                  = merge(var.inherited_tags, var.tags, { Name = local.name })
}
