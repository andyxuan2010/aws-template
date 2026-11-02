mock_provider "aws" {}

run "secure_defaults" {
  command = plan

  variables {
    region_code = "use1"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_policy
    error_message = "Public bucket policies must be blocked by default."
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "Versioning must be enabled by default."
  }

  assert {
    condition     = output.name == "s3-platform-use1-dev-001"
    error_message = "Generated bucket name is incorrect."
  }

  assert {
    condition     = !aws_s3_bucket.this.force_destroy
    error_message = "force_destroy must be disabled by default."
  }
}

run "reject_force_destroy_in_production" {
  command = plan

  variables {
    region_code   = "use1"
    environment   = "prod"
    force_destroy = true
  }

  expect_failures = [aws_s3_bucket.this]
}
