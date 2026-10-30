locals {
  generated_name = substr("alb-${var.workload}-${var.region_code}-${var.environment}-${var.instance}", 0, 32)
  name           = var.name != "" ? var.name : local.generated_name
  tags           = merge(var.inherited_tags, var.tags, { Name = local.name })
  target_group_names = {
    for key in keys(var.target_groups) :
    key => substr("${substr(local.name, 0, 20)}-${substr(key, 0, 4)}-${substr(sha1(key), 0, 6)}", 0, 32)
  }
}
