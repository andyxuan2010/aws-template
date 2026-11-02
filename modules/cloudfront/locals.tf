locals {
  tags = merge(var.inherited_tags, var.tags, { Name = var.name })
}
