resource "aws_secretsmanager_secret" "this" {
  name                           = local.name
  description                    = var.description
  kms_key_id                     = var.kms_key_id
  recovery_window_in_days        = var.recovery_window_in_days
  force_overwrite_replica_secret = var.force_overwrite_replica_secret
  tags                           = local.tags

  dynamic "replica" {
    for_each = var.replicas
    content {
      region     = replica.value.region
      kms_key_id = replica.value.kms_key_id
    }
  }

  lifecycle {
    precondition {
      condition     = var.environment != "prod" || var.recovery_window_in_days == 30
      error_message = "Production secrets must use the 30-day recovery window."
    }
  }
}

resource "aws_secretsmanager_secret_policy" "this" {
  count = var.resource_policy_json == null ? 0 : 1

  secret_arn          = aws_secretsmanager_secret.this.arn
  policy              = var.resource_policy_json
  block_public_policy = var.block_public_policy
}

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.rotation == null ? 0 : 1

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation.lambda_arn
  rotate_immediately  = var.rotation.rotate_immediately

  rotation_rules {
    automatically_after_days = var.rotation.schedule_expression == null ? var.rotation.automatically_after_days : null
    duration                 = var.rotation.duration
    schedule_expression      = var.rotation.schedule_expression
  }
}
