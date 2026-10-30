resource "aws_db_subnet_group" "this" {
  name       = "${local.name}-subnets"
  subnet_ids = var.subnet_ids
  tags       = merge(local.tags, { Name = "${local.name}-subnets" })
}

resource "aws_db_instance" "this" {
  identifier                            = local.name
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_class
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  storage_type                          = var.storage_type
  storage_encrypted                     = var.storage_encrypted
  kms_key_id                            = var.kms_key_id
  db_name                               = var.db_name
  username                              = var.master_username
  manage_master_user_password           = var.manage_master_user_password
  master_user_secret_kms_key_id         = var.manage_master_user_password ? var.master_user_secret_kms_key_id : null
  port                                  = var.port
  db_subnet_group_name                  = aws_db_subnet_group.this.name
  vpc_security_group_ids                = var.vpc_security_group_ids
  multi_az                              = var.multi_az
  publicly_accessible                   = var.publicly_accessible
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  maintenance_window                    = var.maintenance_window
  deletion_protection                   = var.deletion_protection
  skip_final_snapshot                   = var.skip_final_snapshot
  final_snapshot_identifier             = var.skip_final_snapshot ? null : local.final_snapshot_identifier
  copy_tags_to_snapshot                 = true
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  tags                                  = local.tags

  lifecycle {
    precondition {
      condition     = var.storage_encrypted
      error_message = "RDS storage encryption is mandatory."
    }

    precondition {
      condition     = var.manage_master_user_password
      error_message = "RDS must manage the master password in Secrets Manager; plaintext passwords are not accepted."
    }

    precondition {
      condition     = !var.publicly_accessible
      error_message = "Publicly accessible databases are prohibited."
    }

    precondition {
      condition     = var.environment != "prod" || (var.multi_az && var.deletion_protection && !var.skip_final_snapshot && var.backup_retention_period == 35)
      error_message = "Production requires Multi-AZ, deletion protection, a final snapshot, and 35-day backups."
    }

    precondition {
      condition     = var.max_allocated_storage == 0 || var.max_allocated_storage >= var.allocated_storage
      error_message = "max_allocated_storage must be zero or at least allocated_storage."
    }
  }
}
