resource "aws_kms_key" "this" {
  description              = var.description
  policy                   = var.key_policy_json
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  enable_key_rotation      = var.enable_key_rotation
  multi_region             = var.multi_region
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  tags                     = local.tags

  lifecycle {
    precondition {
      condition = (
        var.customer_master_key_spec == "SYMMETRIC_DEFAULT" && var.key_usage == "ENCRYPT_DECRYPT"
        ) || (
        startswith(var.customer_master_key_spec, "HMAC_") && var.key_usage == "GENERATE_VERIFY_MAC"
        ) || (
        !startswith(var.customer_master_key_spec, "HMAC_") &&
        var.customer_master_key_spec != "SYMMETRIC_DEFAULT" &&
        contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY"], var.key_usage)
      )
      error_message = "customer_master_key_spec and key_usage are incompatible."
    }

    precondition {
      condition     = !var.enable_key_rotation || (var.customer_master_key_spec == "SYMMETRIC_DEFAULT" && var.key_usage == "ENCRYPT_DECRYPT")
      error_message = "Automatic key rotation is supported by this module only for symmetric ENCRYPT_DECRYPT keys."
    }

    precondition {
      condition     = var.environment != "prod" || var.deletion_window_in_days == 30
      error_message = "Production keys must use the 30-day deletion window."
    }
  }
}

resource "aws_kms_alias" "this" {
  count = var.enable_alias ? 1 : 0

  name          = local.alias_name
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_grant" "this" {
  for_each = var.grants

  name               = each.key
  key_id             = aws_kms_key.this.key_id
  grantee_principal  = each.value.grantee_principal
  operations         = each.value.operations
  retiring_principal = each.value.retiring_principal

  dynamic "constraints" {
    for_each = each.value.constraints == null ? [] : [each.value.constraints]
    content {
      encryption_context_equals = constraints.value.encryption_context_equals
      encryption_context_subset = constraints.value.encryption_context_subset
    }
  }
}
