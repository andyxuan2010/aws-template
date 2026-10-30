resource "aws_elasticache_subnet_group" "this" {
  name       = local.name
  subnet_ids = var.subnet_ids
  tags       = local.tags
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = local.name
  description                = "${var.workload} ${var.environment} cache"
  engine                     = var.engine
  engine_version             = var.engine_version
  node_type                  = var.node_type
  parameter_group_name       = var.parameter_group_name
  num_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled = true
  multi_az_enabled           = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  kms_key_id                 = var.kms_key_id
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = var.security_group_ids
  user_group_ids             = var.user_group_ids
  snapshot_retention_limit   = var.snapshot_retention_limit
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = true
  apply_immediately          = false
  tags                       = local.tags
}
