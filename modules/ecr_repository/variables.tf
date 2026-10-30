variable "name" {
  type        = string
  description = "Explicit repository name. When empty, the standard name is generated."
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

variable "image_tag_mutability" {
  type        = string
  description = "Whether image tags can be overwritten."
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  type        = bool
  description = "Scan images when pushed."
  default     = true
}

variable "encryption_type" {
  type        = string
  description = "Repository encryption type."
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN required when encryption_type is KMS."
  default     = null
}

variable "force_delete" {
  type        = bool
  description = "Delete images when destroying the repository."
  default     = false
}

variable "lifecycle_policy_json" {
  type        = string
  description = "Optional complete ECR lifecycle policy JSON. The secure default expires untagged images after 14 days and retains 50 tagged images."
  default     = null

  validation {
    condition     = var.lifecycle_policy_json == null || can(jsondecode(var.lifecycle_policy_json))
    error_message = "lifecycle_policy_json must be null or valid JSON."
  }
}

variable "repository_policy_json" {
  type        = string
  description = "Optional ECR repository policy JSON."
  default     = null

  validation {
    condition     = var.repository_policy_json == null || can(jsondecode(var.repository_policy_json))
    error_message = "repository_policy_json must be null or valid JSON."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Repository-specific tags."
  default     = {}
}
