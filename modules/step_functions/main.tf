resource "aws_sfn_state_machine" "this" {
  name       = local.name
  role_arn   = var.role_arn
  definition = var.definition
  type       = upper(var.type)
  publish    = var.publish
  tags       = local.tags
  dynamic "logging_configuration" {
    for_each = var.log_destination == null ? [] : [1]
    content {
      log_destination        = var.log_destination
      include_execution_data = var.include_execution_data
      level                  = upper(var.log_level)
    }
  }
  tracing_configuration {
    enabled = var.tracing_enabled
  }
  lifecycle {
    precondition {
      condition     = upper(var.type) != "EXPRESS" || var.log_destination != null
      error_message = "Express state machines require CloudWatch logging."
    }
  }
}
