resource "aws_lambda_function" "this" {
  function_name                  = local.name
  description                    = var.description
  role                           = var.role_arn
  package_type                   = var.package_type
  filename                       = var.package_type == "Zip" ? var.filename : null
  s3_bucket                      = var.package_type == "Zip" && var.s3_package != null ? var.s3_package.bucket : null
  s3_key                         = var.package_type == "Zip" && var.s3_package != null ? var.s3_package.key : null
  s3_object_version              = var.package_type == "Zip" && var.s3_package != null ? var.s3_package.object_version : null
  image_uri                      = var.package_type == "Image" ? var.image_uri : null
  source_code_hash               = var.package_type == "Zip" ? var.source_code_hash : null
  runtime                        = var.package_type == "Zip" ? var.runtime : null
  handler                        = var.package_type == "Zip" ? var.handler : null
  architectures                  = var.architectures
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  publish                        = var.publish
  kms_key_arn                    = var.kms_key_arn
  code_signing_config_arn        = var.code_signing_config_arn
  layers                         = var.package_type == "Zip" ? var.layers : null
  tags                           = local.tags

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  tracing_config {
    mode = var.tracing_mode
  }

  dynamic "environment" {
    for_each = length(var.environment_variables) == 0 ? [] : [var.environment_variables]
    content {
      variables = environment.value
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      subnet_ids                  = vpc_config.value.subnet_ids
      security_group_ids          = vpc_config.value.security_group_ids
      ipv6_allowed_for_dual_stack = vpc_config.value.ipv6_allowed
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [var.dead_letter_target_arn]
    content {
      target_arn = dead_letter_config.value
    }
  }

  lifecycle {
    precondition {
      condition = (
        var.package_type == "Image" &&
        var.image_uri != null &&
        var.filename == null &&
        var.s3_package == null
        ) || (
        var.package_type == "Zip" &&
        var.image_uri == null &&
        ((var.filename != null ? 1 : 0) + (var.s3_package != null ? 1 : 0) == 1) &&
        var.runtime != null &&
        var.handler != null
      )
      error_message = "Image packages require only image_uri; Zip packages require exactly one of filename or s3_package plus runtime and handler."
    }

    precondition {
      condition     = var.environment != "prod" || var.publish
      error_message = "Production functions must publish immutable versions."
    }
  }
}
