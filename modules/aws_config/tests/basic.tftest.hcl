mock_provider "aws" {}

run "secure_recorder_defaults" {
  command = plan

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }

  override_data {
    target = data.aws_partition.current
    values = {
      partition = "aws"
    }
  }

  variables {
    region_code = "use1"
    region      = "us-east-1"
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/11111111-2222-3333-4444-555555555555"
  }

  assert {
    condition     = aws_config_configuration_recorder.this.recording_group[0].all_supported
    error_message = "AWS Config should record all supported resource types by default."
  }

  assert {
    condition     = aws_config_configuration_recorder.this.recording_group[0].include_global_resource_types == false
    error_message = "Global resource recording should be opt-in to avoid duplicate regional recording."
  }

  assert {
    condition     = aws_config_configuration_recorder.this.recording_mode[0].recording_frequency == "CONTINUOUS"
    error_message = "Continuous configuration recording should be the default."
  }

  assert {
    condition     = aws_config_configuration_recorder_status.this.is_enabled
    error_message = "The recorder should start after the delivery channel is configured."
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_acls && aws_s3_bucket_public_access_block.this.block_public_policy
    error_message = "The configuration history bucket should block public access."
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms" && one(aws_s3_bucket_server_side_encryption_configuration.this.rule).apply_server_side_encryption_by_default[0].kms_master_key_id == var.kms_key_arn
    error_message = "The configuration history bucket should use the supplied customer-managed KMS key."
  }

  assert {
    condition     = aws_config_delivery_channel.this.s3_kms_key_arn == var.kms_key_arn
    error_message = "AWS Config should encrypt delivery channel objects with the supplied customer-managed KMS key."
  }

  assert {
    condition     = aws_config_delivery_channel.this.snapshot_delivery_properties[0].delivery_frequency == "TwentyFour_Hours"
    error_message = "Snapshot delivery should default to once every 24 hours."
  }
}

run "reject_empty_resource_selection" {
  command = plan

  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
    }
  }

  override_data {
    target = data.aws_partition.current
    values = {
      partition = "aws"
    }
  }

  variables {
    region_code              = "use1"
    region                   = "us-east-1"
    kms_key_arn              = "arn:aws:kms:us-east-1:123456789012:key/11111111-2222-3333-4444-555555555555"
    record_all_supported     = false
    recording_resource_types = []
  }

  expect_failures = [aws_config_configuration_recorder.this]
}
