variable "name" {
  type        = string
  description = "Explicit function name. When empty, the standard name is generated."
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
  description = "Function description."
  default     = "Managed by Terraform"
}

variable "role_arn" {
  type        = string
  description = "Execution role ARN."

  validation {
    condition     = can(regex("^arn:(aws|aws-us-gov|aws-cn):iam::[0-9]{12}:role/.+$", var.role_arn))
    error_message = "role_arn must be a valid IAM role ARN."
  }
}

variable "package_type" {
  type        = string
  description = "Lambda deployment package type."
  default     = "Zip"

  validation {
    condition     = contains(["Zip", "Image"], var.package_type)
    error_message = "package_type must be Zip or Image."
  }
}

variable "filename" {
  type        = string
  description = "Local ZIP archive path."
  default     = null
}

variable "s3_package" {
  type = object({
    bucket         = string
    key            = string
    object_version = optional(string)
  })
  description = "Optional S3 deployment package."
  default     = null
}

variable "image_uri" {
  type        = string
  description = "Container image URI when package_type is Image."
  default     = null
}

variable "source_code_hash" {
  type        = string
  description = "Base64 SHA-256 of a ZIP package. Strongly recommended for deterministic updates."
  default     = null
}

variable "runtime" {
  type        = string
  description = "Lambda runtime for Zip packages."
  default     = null
}

variable "handler" {
  type        = string
  description = "Lambda handler for Zip packages."
  default     = null
}

variable "architectures" {
  type        = list(string)
  description = "Function instruction-set architecture."
  default     = ["arm64"]

  validation {
    condition     = length(var.architectures) == 1 && contains(["arm64", "x86_64"], var.architectures[0])
    error_message = "architectures must contain exactly one of arm64 or x86_64."
  }
}

variable "memory_size" {
  type        = number
  description = "Memory in MiB."
  default     = 256

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "memory_size must be from 128 through 10240."
  }
}

variable "timeout" {
  type        = number
  description = "Execution timeout in seconds."
  default     = 30

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "timeout must be from 1 through 900 seconds."
  }
}

variable "ephemeral_storage_size" {
  type        = number
  description = "Ephemeral storage in MiB."
  default     = 512

  validation {
    condition     = var.ephemeral_storage_size >= 512 && var.ephemeral_storage_size <= 10240
    error_message = "ephemeral_storage_size must be from 512 through 10240."
  }
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "Reserved concurrency. Null uses unreserved account concurrency."
  default     = null
}

variable "publish" {
  type        = bool
  description = "Publish a new immutable function version."
  default     = true
}

variable "environment_variables" {
  type        = map(string)
  description = "Non-secret environment variables. Store secrets in Secrets Manager and reference them at runtime."
  default     = {}
}

variable "kms_key_arn" {
  type        = string
  description = "Optional KMS key used to encrypt environment variables."
  default     = null
}

variable "vpc_config" {
  type = object({
    subnet_ids         = set(string)
    security_group_ids = set(string)
    ipv6_allowed       = optional(bool, false)
  })
  description = "Optional VPC attachment."
  default     = null
}

variable "dead_letter_target_arn" {
  type        = string
  description = "Optional SQS queue or SNS topic ARN for failed asynchronous invocations."
  default     = null
}

variable "tracing_mode" {
  type        = string
  description = "X-Ray tracing mode."
  default     = "Active"

  validation {
    condition     = contains(["Active", "PassThrough"], var.tracing_mode)
    error_message = "tracing_mode must be Active or PassThrough."
  }
}

variable "code_signing_config_arn" {
  type        = string
  description = "Optional Lambda code-signing configuration ARN."
  default     = null
}

variable "layers" {
  type        = list(string)
  description = "Lambda layer version ARNs."
  default     = []
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Function-specific tags."
  default     = {}
}
