mock_provider "aws" {}

run "secure_metadata_defaults" {
  command = plan

  variables {
    region_code = "use1"
  }

  assert {
    condition     = aws_secretsmanager_secret.this.recovery_window_in_days == 30
    error_message = "Secrets must use the maximum recovery window by default."
  }

  assert {
    condition     = length(aws_secretsmanager_secret_policy.this) == 0
    error_message = "No resource policy should be created implicitly."
  }
}

run "reject_short_production_recovery" {
  command = plan

  variables {
    region_code             = "use1"
    environment             = "prod"
    recovery_window_in_days = 7
  }

  expect_failures = [aws_secretsmanager_secret.this]
}
