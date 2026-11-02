data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  trail_name  = var.name != "" ? var.name : "ct-${var.workload}-${var.region_code}-${var.environment}-${var.instance}"
  bucket_name = "s3-${var.workload}-cloudtrail-${data.aws_caller_identity.current.account_id}-${var.region_code}-${var.environment}-${var.instance}"
  trail_arn   = "arn:${data.aws_partition.current.partition}:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/${local.trail_name}"

  trail_tags  = merge(var.inherited_tags, var.tags, { Name = local.trail_name })
  bucket_tags = merge(var.inherited_tags, var.tags, { Name = local.bucket_name })

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
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}"
        Condition = {
          StringEquals = {
            "aws:SourceArn" = local.trail_arn
          }
        }
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "arn:${data.aws_partition.current.partition}:s3:::${local.bucket_name}/${var.s3_key_prefix}/AWSLogs/*"
        Condition = {
          StringEquals = {
            "aws:SourceArn" = local.trail_arn
            "s3:x-amz-acl"  = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}
