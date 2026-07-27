data "aws_iam_policy_document" "trust" {
  count = var.assume_role_policy_json == null ? 1 : 0

  dynamic "statement" {
    for_each = var.trust_policy_statements

    content {
      sid     = statement.value.sid
      effect  = statement.value.effect
      actions = statement.value.actions

      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = local.name
  description          = var.description
  path                 = var.path
  assume_role_policy   = var.assume_role_policy_json != null ? var.assume_role_policy_json : data.aws_iam_policy_document.trust[0].json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn
  tags                 = local.tags

  lifecycle {
    precondition {
      condition = (
        (var.assume_role_policy_json != null && length(var.trust_policy_statements) == 0) ||
        (var.assume_role_policy_json == null && length(var.trust_policy_statements) > 0)
      )
      error_message = "Set exactly one of assume_role_policy_json or trust_policy_statements."
    }
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.managed_policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "this" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = local.instance_profile_name
  path = var.path
  role = aws_iam_role.this.name
  tags = local.tags
}
