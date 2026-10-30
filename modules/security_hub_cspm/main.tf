resource "aws_securityhub_account" "this" {
  enable_default_standards = false
  auto_enable_controls     = var.auto_enable_controls
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each      = var.standards_arns
  standards_arn = each.value
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_finding_aggregator" "this" {
  count             = local.create_aggregator ? 1 : 0
  linking_mode      = var.aggregation_linking_mode
  specified_regions = var.aggregation_linking_mode == "SPECIFIED_REGIONS" ? var.specified_regions : null
  depends_on        = [aws_securityhub_account.this]

  lifecycle {
    precondition {
      condition     = var.aggregation_linking_mode != "SPECIFIED_REGIONS" || length(var.specified_regions) > 0
      error_message = "SPECIFIED_REGIONS aggregation requires at least one specified Region."

    }

  }
}
