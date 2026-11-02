locals {
  zone_name = trimsuffix(lower(var.zone_name), ".")
  tags = merge(var.inherited_tags, var.tags, {
    Name = local.zone_name
  })
}
