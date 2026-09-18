mock_provider "aws" {}

run "secure_key_defaults" {
  command = plan

  variables {
    region_code = "use1"
  }

  assert {
    condition     = aws_kms_key.this.enable_key_rotation
    error_message = "KMS rotation should be enabled by default."
  }

  assert {
    condition     = aws_kms_key.this.deletion_window_in_days == 30
    error_message = "The default deletion window should be 30 days."
  }

  assert {
    condition     = output.alias_name == "alias/kms-platform-use1-dev-001"
    error_message = "Generated KMS alias is incorrect."
  }
}

run "reject_rotation_for_asymmetric_key" {
  command = plan

  variables {
    region_code              = "use1"
    customer_master_key_spec = "RSA_2048"
    key_usage                = "SIGN_VERIFY"
  }

  expect_failures = [aws_kms_key.this]
}
