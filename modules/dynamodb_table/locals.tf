locals {
  generated_name = "ddb-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  name           = var.name != "" ? var.name : local.generated_name
  tags           = merge(var.inherited_tags, var.tags, { Name = local.name })
  required_attribute_names = toset(concat(
    [var.hash_key],
    var.range_key == null ? [] : [var.range_key],
    flatten([
      for index in values(var.global_secondary_indexes) :
      concat([index.hash_key], index.range_key == null ? [] : [index.range_key])
    ]),
    [for index in values(var.local_secondary_indexes) : index.range_key]
  ))
}
