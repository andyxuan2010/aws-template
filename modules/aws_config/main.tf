resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = false
  tags          = local.bucket_tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = local.bucket_policy

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_iam_role" "this" {
  name               = local.recorder_name
  assume_role_policy = local.config_role_trust_policy
  tags               = local.recorder_tags
}

resource "aws_iam_role_policy_attachment" "config_role" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_iam_role_policy" "bucket_access" {
  name   = "${local.recorder_name}-delivery"
  role   = aws_iam_role.this.id
  policy = local.config_role_policy
}

resource "aws_config_configuration_recorder" "this" {
  name     = "default"
  role_arn = aws_iam_role.this.arn

  recording_group {
    all_supported                 = var.record_all_supported
    include_global_resource_types = var.include_global_resource_types
    resource_types                = var.record_all_supported ? null : var.recording_resource_types
  }

  recording_mode {
    recording_frequency = var.recording_frequency
  }

  lifecycle {
    precondition {
      condition = var.record_all_supported ? (
        length(var.recording_resource_types) == 0
        ) : (
        length(var.recording_resource_types) > 0
      )
      error_message = "Set recording_resource_types only when record_all_supported is false, and provide at least one type in that mode."
    }
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.this.id
  s3_key_prefix  = var.s3_key_prefix
  s3_kms_key_arn = var.kms_key_arn

  snapshot_delivery_properties {
    delivery_frequency = var.snapshot_delivery_frequency
  }

  depends_on = [
    aws_config_configuration_recorder.this,
    aws_s3_bucket_policy.this
  ]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.this,
    aws_s3_bucket_policy.this,
    aws_iam_role_policy_attachment.config_role,
    aws_iam_role_policy.bucket_access
  ]
}
