locals {
  endpoint_names = {
    for key in keys(var.endpoints) : key => "vpce-${var.workload}-${key}-${var.region_code}-${var.environment}-${var.instance}"
  }
}
