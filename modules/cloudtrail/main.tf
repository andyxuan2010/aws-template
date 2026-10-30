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

resource "aws_cloudtrail" "this" {
  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.this.id
  s3_key_prefix                 = var.s3_key_prefix
  kms_key_id                    = var.kms_key_arn
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = var.is_organization_trail
  enable_log_file_validation    = true
  enable_logging                = true
  tags                          = local.trail_tags

  depends_on = [aws_s3_bucket_policy.this]
}
