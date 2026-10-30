variable "name" {
  type        = string
  description = "Optional explicit CloudTrail name. When empty, the standard name is generated."
  default     = ""

  validation {
    condition     = var.name == "" || can(regex("^[A-Za-z0-9._-]{3,128}$", var.name))
    error_message = "name must be empty or a 3-128 character CloudTrail name using letters, numbers, dots, hyphens, or underscores."
  }
}

variable "workload" {
  type        = string
  description = "Lowercase workload identifier used in generated names."
  default     = "platform"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,11}$", var.workload))
    error_message = "workload must be 1-12 lowercase letters, numbers, or internal hyphens, and start with a letter or number."
  }
}

variable "region_code" {
  type        = string
  description = "Short region code, for example use1."

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
  description = "ARN of the customer-managed KMS key used to encrypt CloudTrail log objects."

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

variable "s3_key_prefix" {
  type        = string
  description = "Prefix for CloudTrail log objects in the dedicated S3 bucket."
  default     = "cloudtrail"

  validation {
    condition     = length(var.s3_key_prefix) <= 128 && !startswith(var.s3_key_prefix, "/") && !endswith(var.s3_key_prefix, "/")
    error_message = "s3_key_prefix must be at most 128 characters and must not start or end with a slash."
  }
}

variable "is_organization_trail" {
  type        = bool
  description = "Create an organization trail. Requires Organizations setup and suitable permissions in the calling account."
  default     = false
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
