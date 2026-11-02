data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  recorder_name     = "cfg-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  bucket_name       = "s3-${var.workload}-config-${data.aws_caller_identity.current.account_id}-${var.region_code}-${var.environment}-${var.instance}"
  config_source_arn = "arn:${data.aws_partition.current.partition}:config:${var.region}:${data.aws_caller_identity.current.account_id}:*"

  resource_tags = merge(var.inherited_tags, var.tags)
  recorder_tags = merge(local.resource_tags, { Name = local.recorder_name })
  bucket_tags   = merge(local.resource_tags, { Name = local.bucket_name })

  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}",
          "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid       = "AWSConfigBucketPermissionsCheck"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}"
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "AWS:SourceArn" = local.config_source_arn
          }
        }
      },
      {
        Sid       = "AWSConfigBucketExistenceCheck"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "s3:ListBucket"
        Resource  = "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}"
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "AWS:SourceArn" = local.config_source_arn
          }
        }
      },
      {
        Sid       = "AWSConfigBucketDelivery"
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/${var.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "AWS:SourceArn" = local.config_source_arn
          }
        }
      }
    ]
  })

  config_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ConfigBucketExistenceCheck"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}"
      },
      {
        Sid      = "ConfigBucketDelivery"
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:PutObjectAcl"]
        Resource = "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/${var.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
        Condition = {
          StringLike = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })

  config_role_trust_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action    = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = local.config_source_arn
          }
        }
      }
    ]
  })
}
