variable "name" {
  type        = string
  description = "Explicit table name. When empty, the standard name is generated."
  default     = ""
}

variable "workload" {
  type        = string
  description = "Workload identifier."
  default     = "platform"
}

variable "region_code" {
  type        = string
  description = "Short AWS region code."
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"

  validation {
    condition     = contains(["prod", "staging", "dev", "qa", "test", "sbx", "poc"], var.environment)
    error_message = "environment is not supported."
  }
}

variable "instance" {
  type        = string
  description = "Three-digit resource instance."
  default     = "001"

  validation {
    condition     = can(regex("^[0-9]{3}$", var.instance))
    error_message = "instance must be a three-digit string."
  }
}

variable "hash_key" {
  type        = string
  description = "Partition key attribute name."
}

variable "range_key" {
  type        = string
  description = "Optional sort key attribute name."
  default     = null
}

variable "attributes" {
  type = map(object({
    type = string
  }))
  description = "Key attributes only, keyed by attribute name."

  validation {
    condition     = alltrue([for attribute in values(var.attributes) : contains(["S", "N", "B"], attribute.type)])
    error_message = "Attribute types must be S, N, or B."
  }
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB billing mode."
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "read_capacity" {
  type        = number
  description = "Provisioned read capacity when billing_mode is PROVISIONED."
  default     = null
}

variable "write_capacity" {
  type        = number
  description = "Provisioned write capacity when billing_mode is PROVISIONED."
  default     = null
}

variable "global_secondary_indexes" {
  type = map(object({
    hash_key           = string
    range_key          = optional(string)
    projection_type    = optional(string, "ALL")
    non_key_attributes = optional(set(string), [])
    read_capacity      = optional(number)
    write_capacity     = optional(number)
  }))
  description = "Global secondary indexes keyed by stable index name."
  default     = {}

  validation {
    condition     = alltrue([for index in values(var.global_secondary_indexes) : contains(["ALL", "KEYS_ONLY", "INCLUDE"], index.projection_type)])
    error_message = "GSI projection_type must be ALL, KEYS_ONLY, or INCLUDE."
  }
}

variable "local_secondary_indexes" {
  type = map(object({
    range_key          = string
    projection_type    = optional(string, "ALL")
    non_key_attributes = optional(set(string), [])
  }))
  description = "Local secondary indexes keyed by stable index name."
  default     = {}
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable point-in-time recovery."
  default     = true
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Protect the table from deletion."
  default     = true
}

variable "server_side_encryption_enabled" {
  type        = bool
  description = "Enable server-side encryption."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "Optional customer-managed KMS key ARN."
  default     = null
}

variable "table_class" {
  type        = string
  description = "DynamoDB table class."
  default     = "STANDARD"
}

variable "ttl_attribute_name" {
  type        = string
  description = "Optional TTL attribute name."
  default     = null
}

variable "stream_enabled" {
  type        = bool
  description = "Enable DynamoDB Streams."
  default     = false
}

variable "stream_view_type" {
  type        = string
  description = "Stream record view type."
  default     = null

  validation {
    condition     = var.stream_view_type == null || contains(["KEYS_ONLY", "NEW_IMAGE", "OLD_IMAGE", "NEW_AND_OLD_IMAGES"], var.stream_view_type)
    error_message = "stream_view_type is invalid."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Table-specific tags."
  default     = {}
}
