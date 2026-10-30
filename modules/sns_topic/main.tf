resource "aws_sns_topic" "this" {
  name                        = local.name
  display_name                = var.display_name
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : null
  fifo_throughput_scope       = var.fifo_topic ? var.fifo_throughput_scope : null
  kms_master_key_id           = var.kms_master_key_id
  signature_version           = var.signature_version
  tracing_config              = var.fifo_topic ? null : var.tracing_config
  archive_policy              = var.fifo_topic ? var.archive_policy_json : null
  policy                      = var.topic_policy_json
  tags                        = local.tags

  lifecycle {
    precondition {
      condition     = var.fifo_topic || (!var.content_based_deduplication && var.fifo_throughput_scope == null && var.archive_policy_json == null)
      error_message = "FIFO-only settings cannot be used with a standard topic."
    }

    precondition {
      condition     = var.allow_insecure_http_subscriptions || alltrue([for value in values(var.subscriptions) : value.protocol != "http"])
      error_message = "Plaintext HTTP subscriptions require allow_insecure_http_subscriptions = true."
    }
  }
}

resource "aws_sns_topic_data_protection_policy" "this" {
  count = var.data_protection_policy_json == null ? 0 : 1

  arn    = aws_sns_topic.this.arn
  policy = var.data_protection_policy_json
}

resource "aws_sns_topic_subscription" "this" {
  for_each = var.subscriptions

  topic_arn                       = aws_sns_topic.this.arn
  protocol                        = each.value.protocol
  endpoint                        = each.value.endpoint
  endpoint_auto_confirms          = each.value.endpoint_auto_confirms
  confirmation_timeout_in_minutes = each.value.confirmation_timeout_in_minutes
  raw_message_delivery            = each.value.raw_message_delivery
  filter_policy                   = each.value.filter_policy
  filter_policy_scope             = each.value.filter_policy_scope
  redrive_policy                  = each.value.redrive_policy
  subscription_role_arn           = each.value.subscription_role_arn
}
