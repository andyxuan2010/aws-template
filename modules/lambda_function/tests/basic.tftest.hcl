mock_provider "aws" {}

run "secure_zip_defaults" {
  command = plan

  variables {
    region_code = "use1"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-role"
    filename    = "function.zip"
    runtime     = "python3.13"
    handler     = "handler.main"
  }

  assert {
    condition     = aws_lambda_function.this.tracing_config[0].mode == "Active"
    error_message = "Active tracing must be enabled by default."
  }

  assert {
    condition     = aws_lambda_function.this.publish
    error_message = "Function versions must be published by default."
  }
}

run "reject_ambiguous_package_source" {
  command = plan

  variables {
    region_code = "use1"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-role"
    filename    = "function.zip"
    s3_package = {
      bucket = "artifacts"
      key    = "function.zip"
    }
    runtime = "python3.13"
    handler = "handler.main"
  }

  expect_failures = [aws_lambda_function.this]
}
