resource "aws_dynamodb_table" "this" {
  name                        = local.name
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  read_capacity               = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity              = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  deletion_protection_enabled = var.deletion_protection_enabled
  table_class                 = var.table_class
  stream_enabled              = var.stream_enabled
  stream_view_type            = var.stream_enabled ? var.stream_view_type : null
  tags                        = local.tags

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.key
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = global_secondary_index.key
      hash_key           = global_secondary_index.value.hash_key
      range_key          = global_secondary_index.value.range_key
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.projection_type == "INCLUDE" ? global_secondary_index.value.non_key_attributes : null
      read_capacity      = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.read_capacity : null
      write_capacity     = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.write_capacity : null
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = local_secondary_index.key
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.projection_type == "INCLUDE" ? local_secondary_index.value.non_key_attributes : null
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.kms_key_arn
  }

  dynamic "ttl" {
    for_each = var.ttl_attribute_name == null ? [] : [var.ttl_attribute_name]
    content {
      enabled        = true
      attribute_name = ttl.value
    }
  }

  lifecycle {
    precondition {
      condition     = local.required_attribute_names == toset(keys(var.attributes))
      error_message = "attributes must define exactly the table and index key attributes; non-key attributes must not be declared."
    }

    precondition {
      condition = (
        var.billing_mode == "PAY_PER_REQUEST" &&
        var.read_capacity == null &&
        var.write_capacity == null
        ) || (
        var.billing_mode == "PROVISIONED" &&
        var.read_capacity != null &&
        var.write_capacity != null &&
        alltrue([
          for index in values(var.global_secondary_indexes) :
          index.read_capacity != null && index.write_capacity != null
        ])
      )
      error_message = "Provisioned mode requires table and GSI capacities; on-demand mode must omit them."
    }

    precondition {
      condition     = var.server_side_encryption_enabled
      error_message = "Server-side encryption is mandatory."
    }

    precondition {
      condition     = !var.stream_enabled || var.stream_view_type != null
      error_message = "stream_view_type is required when streams are enabled."
    }

    precondition {
      condition     = var.environment != "prod" || (var.point_in_time_recovery_enabled && var.deletion_protection_enabled)
      error_message = "Production requires point-in-time recovery and deletion protection."
    }
  }
}
