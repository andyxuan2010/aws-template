mock_provider "aws" {}

run "secure_multi_region_defaults" {
  command = plan

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }

  variables {
    region_code = "use1"
    region      = "us-east-1"
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/11111111-2222-3333-4444-555555555555"
  }

  assert {
    condition     = aws_cloudtrail.this.is_multi_region_trail
    error_message = "CloudTrail should be multi-region by default."
  }

  assert {
    condition     = aws_cloudtrail.this.include_global_service_events
    error_message = "CloudTrail should include global service events by default."
  }

  assert {
    condition     = aws_cloudtrail.this.enable_log_file_validation
    error_message = "CloudTrail log file validation should be enabled by default."
  }

  assert {
    condition     = aws_cloudtrail.this.s3_key_prefix == "cloudtrail"
    error_message = "CloudTrail should write under the configured prefix."
  }

  assert {
    condition     = output.trail_name == "ct-platform-use1-dev-001"
    error_message = "Generated CloudTrail name does not follow the repository naming convention."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_acls && aws_s3_bucket_public_access_block.this.block_public_policy
    error_message = "All S3 public access blocks should be enabled."
  }

  assert {
    condition     = aws_s3_bucket_versioning.this.versioning_configuration[0].status == "Enabled"
    error_message = "The CloudTrail log bucket should have versioning enabled."
  }

  assert {
    condition     = aws_s3_bucket_ownership_controls.this.rule[0].object_ownership == "BucketOwnerEnforced"
    error_message = "The CloudTrail log bucket should disable object ACLs."
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms" && one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].kms_master_key_id == var.kms_key_arn
    error_message = "The CloudTrail log bucket should use the supplied customer-managed KMS key."
  }

  assert {
    condition     = aws_cloudtrail.this.kms_key_id == var.kms_key_arn
    error_message = "CloudTrail should encrypt log files with the supplied customer-managed KMS key."
  }
}

run "reject_invalid_s3_prefix" {
  command = plan

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }

  variables {
    region_code   = "use1"
    region        = "us-east-1"
    kms_key_arn   = "arn:aws:kms:us-east-1:123456789012:key/11111111-2222-3333-4444-555555555555"
    s3_key_prefix = "/invalid/"
  }

  expect_failures = [var.s3_key_prefix]
}
