resource "aws_sqs_queue" "this" {
  name                              = local.name
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.fifo_queue ? var.content_based_deduplication : null
  deduplication_scope               = var.fifo_queue ? var.deduplication_scope : null
  fifo_throughput_limit             = var.fifo_queue ? var.fifo_throughput_limit : null
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  max_message_size                  = var.max_message_size
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  sqs_managed_sse_enabled           = var.kms_key_id == null
  kms_master_key_id                 = var.kms_key_id
  kms_data_key_reuse_period_seconds = var.kms_key_id == null ? null : var.kms_data_key_reuse_period_seconds
  redrive_policy = var.dead_letter_queue == null ? null : jsonencode({
    deadLetterTargetArn = var.dead_letter_queue.arn
    maxReceiveCount     = var.dead_letter_queue.max_receive_count
  })
  policy = var.queue_policy_json
  tags   = local.tags

  lifecycle {
    precondition {
      condition     = var.fifo_queue || (!var.content_based_deduplication && var.deduplication_scope == null && var.fifo_throughput_limit == null)
      error_message = "FIFO-only settings cannot be used with a standard queue."
    }

    precondition {
      condition     = var.environment != "prod" || var.dead_letter_queue != null
      error_message = "Production queues require a dead-letter queue."
    }
  }
}
