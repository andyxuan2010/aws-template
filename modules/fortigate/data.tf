data "aws_ami" "selected" {
  count = var.ami_id == null ? 1 : 0

  most_recent = var.image_lookup == null ? false : var.image_lookup.most_recent
  owners      = var.image_lookup == null ? [] : var.image_lookup.owners

  dynamic "filter" {
    for_each = var.image_lookup == null ? {} : var.image_lookup.filters

    content {
      name   = filter.key
      values = filter.value
    }
  }
}
