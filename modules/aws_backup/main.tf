resource "aws_backup_vault" "this" {
  name          = local.name
  kms_key_arn   = var.kms_key_arn
  force_destroy = var.force_destroy
  tags          = local.tags
  lifecycle {
    precondition {
      condition     = var.environment != "prod" || !var.force_destroy
      error_message = "force_destroy cannot be enabled in production."
    }
  }
}
resource "aws_backup_vault_lock_configuration" "this" {
  count               = var.lock_configuration == null ? 0 : 1
  backup_vault_name   = aws_backup_vault.this.name
  min_retention_days  = var.lock_configuration.min_retention_days
  max_retention_days  = var.lock_configuration.max_retention_days
  changeable_for_days = var.lock_configuration.changeable_for_days
}
resource "aws_backup_plan" "this" {
  name = local.name
  tags = local.tags
  dynamic "rule" {
    for_each = var.rules
    content {
      rule_name                = rule.key
      target_vault_name        = aws_backup_vault.this.name
      schedule                 = rule.value.schedule
      start_window             = rule.value.start_window
      completion_window        = rule.value.completion_window
      enable_continuous_backup = rule.value.enable_continuous_backup
      dynamic "lifecycle" {
        for_each = rule.value.lifecycle == null ? [] : [rule.value.lifecycle]
        content {
          cold_storage_after = lifecycle.value.cold_storage_after
          delete_after       = lifecycle.value.delete_after
        }
      }
      dynamic "copy_action" {
        for_each = rule.value.copy_actions
        content {
          destination_vault_arn = copy_action.value.destination_vault_arn
          dynamic "lifecycle" {
            for_each = copy_action.value.lifecycle == null ? [] : [copy_action.value.lifecycle]
            content {
              cold_storage_after = lifecycle.value.cold_storage_after
              delete_after       = lifecycle.value.delete_after
            }
          }
        }
      }
    }
  }
}
resource "aws_backup_selection" "this" {
  for_each      = var.selections
  iam_role_arn  = each.value.iam_role_arn
  name          = "${local.name}-${each.key}"
  plan_id       = aws_backup_plan.this.id
  resources     = each.value.resources
  not_resources = each.value.not_resources
  dynamic "condition" {
    for_each = each.value.conditions
    content {
      dynamic "string_equals" {
        for_each = condition.value.type == "STRINGEQUALS" ? [1] : []
        content {
          key   = condition.value.key
          value = condition.value.value
        }
      }
      dynamic "string_like" {
        for_each = condition.value.type == "STRINGLIKE" ? [1] : []
        content {
          key   = condition.value.key
          value = condition.value.value
        }
      }
    }
  }
}
