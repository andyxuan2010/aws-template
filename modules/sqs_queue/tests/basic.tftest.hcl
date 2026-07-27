mock_provider "aws" {}

run "secure_standard_defaults" {
  command = plan

  variables {
    region_code = "use1"
  }

  assert {
    condition     = aws_sqs_queue.this.sqs_managed_sse_enabled
    error_message = "SQS-managed encryption must be enabled by default."
  }

  assert {
    condition     = aws_sqs_queue.this.receive_wait_time_seconds == 20
    error_message = "Long polling must be enabled by default."
  }
}

run "reject_production_without_dlq" {
  command = plan

  variables {
    region_code = "use1"
    environment = "prod"
  }

  expect_failures = [aws_sqs_queue.this]
}
