locals {
  bus_name   = var.name != "" ? var.name : "event-${var.workload}-${var.environment}-${var.instance}"
  create_bus = var.name != ""
  tags       = merge(var.inherited_tags, var.tags, { Name = local.bus_name })
  targets    = merge([for rule_key, rule in var.rules : { for target_key, target in rule.targets : "${rule_key}.${target_key}" => merge(target, { rule_key = rule_key, target_key = target_key }) }]...)
}
