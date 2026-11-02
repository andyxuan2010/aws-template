mock_provider "aws" {}

run "encrypted_multi_az_cache" {
  command = plan

  variables {
    region_code        = "use1"
    engine_version     = "7.2"
    node_type          = "cache.t4g.small"
    subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    security_group_ids = ["sg-0123456789abcdef0"]
    user_group_ids     = ["user-group-app"]
  }

  assert {
    condition     = aws_elasticache_replication_group.this.at_rest_encryption_enabled && aws_elasticache_replication_group.this.transit_encryption_enabled
    error_message = "ElastiCache data must be encrypted at rest and in transit."
  }

  assert {
    condition     = aws_elasticache_replication_group.this.multi_az_enabled && aws_elasticache_replication_group.this.automatic_failover_enabled
    error_message = "ElastiCache must use Multi-AZ and automatic failover."
  }

  assert {
    condition     = aws_elasticache_replication_group.this.snapshot_retention_limit == 7 && !aws_elasticache_replication_group.this.apply_immediately
    error_message = "The default backup retention and deferred maintenance policy changed."
  }
}
