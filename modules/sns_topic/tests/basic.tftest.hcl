mock_provider "aws" {}

run "secure_topic_defaults" {
  command = plan

  variables {
    region_code       = "use1"
    kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/00000000-0000-0000-0000-000000000001"
  }

  assert {
    condition     = aws_sns_topic.this.kms_master_key_id == "arn:aws:kms:us-east-1:123456789012:key/00000000-0000-0000-0000-000000000001"
    error_message = "SNS encryption must be enabled by default."
  }

  assert {
    condition     = aws_sns_topic.this.signature_version == 2
    error_message = "SNS signature version 2 must be used."
  }
}

run "reject_plaintext_http_subscription" {
  command = plan

  variables {
    region_code       = "use1"
    kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/00000000-0000-0000-0000-000000000001"
    subscriptions = {
      insecure = {
        protocol = "http"
        endpoint = "http://example.com/events"
      }
    }
  }

  expect_failures = [aws_sns_topic.this]
}
