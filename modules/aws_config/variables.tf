variable "workload" {
  type        = string
  description = "Lowercase workload identifier used in generated resource names."
  default     = "platform"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,11}$", var.workload))
    error_message = "workload must be 1-12 lowercase letters, numbers, or internal hyphens."
  }
}

variable "region_code" {
  type        = string
  description = "Short region code used in generated names, for example use1."

  validation {
    condition     = can(regex("^[a-z0-9-]{1,9}$", var.region_code))
    error_message = "region_code must be 1-9 lowercase letters, numbers, or hyphens."
  }
}

variable "region" {
  type        = string
  description = "AWS Region name matching the provider region, for example us-east-1."

  validation {
    condition     = can(regex("^[a-z0-9-]{3,32}$", var.region)) && can(regex("-[0-9]+$", var.region))
    error_message = "region must be a valid lowercase AWS Region name such as us-east-1."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the customer-managed KMS key used to encrypt AWS Config objects and delivery channel data."

  validation {
    condition     = can(regex("^arn:[^:]+:kms:[a-z0-9-]+:[0-9]{12}:key/.+$", var.kms_key_arn))
    error_message = "kms_key_arn must be a customer-managed KMS key ARN."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"

  validation {
    condition     = contains(["prod", "staging", "dev", "qa", "test", "sbx", "poc"], var.environment)
    error_message = "environment must be one of: prod, staging, dev, qa, test, sbx, poc."
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

variable "record_all_supported" {
  type        = bool
  description = "Record all supported resource types, including new types as AWS Config supports them."
  default     = true
}

variable "recording_resource_types" {
  type        = set(string)
  description = "Resource types to record when record_all_supported is false."
  default     = []
}

variable "include_global_resource_types" {
  type        = bool
  description = "Include global resource types. Enable only in the designated Region for global resource recording."
  default     = false
}

variable "recording_frequency" {
  type        = string
  description = "Configuration recording frequency. Continuous recording is the default for prompt change capture."
  default     = "CONTINUOUS"

  validation {
    condition     = contains(["CONTINUOUS", "DAILY"], var.recording_frequency)
    error_message = "recording_frequency must be CONTINUOUS or DAILY."
  }
}

variable "snapshot_delivery_frequency" {
  type        = string
  description = "Frequency for recurring configuration snapshots delivered to S3."
  default     = "TwentyFour_Hours"

  validation {
    condition     = contains(["One_Hour", "Three_Hours", "Six_Hours", "Twelve_Hours", "TwentyFour_Hours"], var.snapshot_delivery_frequency)
    error_message = "snapshot_delivery_frequency must be One_Hour, Three_Hours, Six_Hours, Twelve_Hours, or TwentyFour_Hours."
  }
}

variable "s3_key_prefix" {
  type        = string
  description = "Prefix for AWS Config history and snapshots in the dedicated S3 bucket."
  default     = "config"

  validation {
    condition     = length(var.s3_key_prefix) <= 128 && !startswith(var.s3_key_prefix, "/") && !endswith(var.s3_key_prefix, "/")
    error_message = "s3_key_prefix must be at most 128 characters and must not start or end with a slash."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource-specific tags."
  default     = {}
}
