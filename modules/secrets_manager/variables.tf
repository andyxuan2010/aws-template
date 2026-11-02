variable "name" {
  type        = string
  description = "Explicit secret name. When empty, the standard name is generated."
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

variable "description" {
  type        = string
  description = "Secret purpose and ownership description."
  default     = "Secret metadata managed by Terraform"
}

variable "kms_key_id" {
  type        = string
  description = "Optional customer-managed KMS key ARN or ID."
  default     = null
}

variable "recovery_window_in_days" {
  type        = number
  description = "Recovery window before permanent secret deletion."
  default     = 30

  validation {
    condition     = var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30
    error_message = "recovery_window_in_days must be from 7 through 30."
  }
}

variable "force_overwrite_replica_secret" {
  type        = bool
  description = "Allow replica creation to overwrite a same-named replica secret."
  default     = false
}

variable "replicas" {
  type = map(object({
    region     = string
    kms_key_id = optional(string)
  }))
  description = "Replica definitions keyed by stable logical name."
  default     = {}

  validation {
    condition     = alltrue([for replica in values(var.replicas) : can(regex("^[a-z]{2}(?:-gov)?-[a-z]+-[0-9]$", replica.region))])
    error_message = "Every replica region must be a valid AWS region identifier."
  }
}

variable "resource_policy_json" {
  type        = string
  description = "Optional resource-based policy JSON."
  default     = null

  validation {
    condition     = var.resource_policy_json == null || can(jsondecode(var.resource_policy_json))
    error_message = "resource_policy_json must be null or valid JSON."
  }
}

variable "block_public_policy" {
  type        = bool
  description = "Reject policies that grant broad public access."
  default     = true
}

variable "rotation" {
  type = object({
    lambda_arn               = string
    automatically_after_days = optional(number, 30)
    duration                 = optional(string)
    schedule_expression      = optional(string)
    rotate_immediately       = optional(bool, false)
  })
  description = "Optional Lambda-based rotation configuration."
  default     = null

  validation {
    condition     = var.rotation == null || var.rotation.automatically_after_days == null || (var.rotation.automatically_after_days >= 1 && var.rotation.automatically_after_days <= 1000)
    error_message = "rotation.automatically_after_days must be null or from 1 through 1000."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Secret-specific tags."
  default     = {}
}
