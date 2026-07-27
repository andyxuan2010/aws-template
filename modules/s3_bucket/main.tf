resource "aws_s3_bucket" "this" {
  bucket              = local.name
  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock.enabled
  tags                = local.tags

  lifecycle {
    precondition {
      condition     = var.environment != "prod" || !var.force_destroy
      error_message = "force_destroy cannot be enabled for a production bucket."
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status     = var.versioning_enabled ? "Enabled" : "Suspended"
    mfa_delete = "Disabled"
  }

  lifecycle {
    precondition {
      condition     = !var.object_lock.enabled || var.versioning_enabled
      error_message = "S3 Object Lock requires versioning_enabled = true."
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = var.kms_key_arn != null ? var.bucket_key_enabled : null

    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      id     = rule.key
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = coalesce(rule.value.prefix, "")
      }

      dynamic "expiration" {
        for_each = rule.value.expiration_days == null ? [] : [rule.value.expiration_days]
        content {
          days = expiration.value
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration == null ? [] : [rule.value.noncurrent_version_expiration]
        content {
          noncurrent_days = noncurrent_version_expiration.value
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_days == null ? [] : [rule.value.abort_incomplete_multipart_days]
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_logging" "this" {
  count = var.access_logging == null ? 0 : 1

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.access_logging.target_bucket
  target_prefix = var.access_logging.target_prefix
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = var.object_lock.enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode = var.object_lock.mode
      days = var.object_lock.retention_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

data "aws_iam_policy_document" "tls" {
  count = var.enforce_tls ? 1 : 0

  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "combined" {
  count = var.enforce_tls && var.bucket_policy_json != null ? 1 : 0

  source_policy_documents = [
    data.aws_iam_policy_document.tls[0].json,
    var.bucket_policy_json
  ]
}

resource "aws_s3_bucket_policy" "this" {
  count = var.enforce_tls || var.bucket_policy_json != null ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = (
    var.enforce_tls && var.bucket_policy_json != null ? data.aws_iam_policy_document.combined[0].json :
    var.enforce_tls ? data.aws_iam_policy_document.tls[0].json :
    var.bucket_policy_json
  )

  depends_on = [aws_s3_bucket_public_access_block.this]
}
