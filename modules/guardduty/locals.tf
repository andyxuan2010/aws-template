locals {
  detector_name = "gd-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  detector_tags = merge(var.inherited_tags, var.tags, { Name = local.detector_name })
}
