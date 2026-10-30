resource "aws_ecr_repository" "this" {
  name                 = local.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete
  tags                 = local.tags

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key_arn : null
  }

  lifecycle {
    precondition {
      condition     = var.encryption_type != "KMS" || var.kms_key_arn != null
      error_message = "kms_key_arn is required when encryption_type is KMS."
    }

    precondition {
      condition     = var.environment != "prod" || (var.image_tag_mutability == "IMMUTABLE" && var.scan_on_push && !var.force_delete)
      error_message = "Production requires immutable tags, scan-on-push, and force_delete disabled."
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = coalesce(var.lifecycle_policy_json, local.default_lifecycle_policy)
}

resource "aws_ecr_repository_policy" "this" {
  count = var.repository_policy_json == null ? 0 : 1

  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy_json
}
