variable "name" {
  type        = string
  description = "Explicit globally unique bucket name. When empty, the standard name is generated."
  default     = ""

  validation {
    condition     = var.name == "" || can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.name))
    error_message = "name must be empty or a valid 3-63 character S3 bucket name."
  }
}

variable "workload" {
  type        = string
  description = "Workload identifier."
  default     = "platform"
}

variable "region_code" {
  type        = string
  description = "Short region code, for example use1."
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

variable "force_destroy" {
  type        = bool
  description = "Allow deletion of a non-empty bucket. Keep false for durable environments."
  default     = false
}

variable "object_ownership" {
  type        = string
  description = "S3 Object Ownership mode."
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  }
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable S3 object versioning."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for SSE-KMS. When null, SSE-S3 AES256 encryption is used."
  default     = null
}

variable "access_logging" {
  type = object({
    target_bucket = string
    target_prefix = optional(string, "access-logs/")
  })
  description = "Optional server access logging destination. Use a separate log bucket to avoid recursive logging."
  default     = null
}

variable "object_lock" {
  type = object({
    enabled        = optional(bool, false)
    mode           = optional(string, "GOVERNANCE")
    retention_days = optional(number, 30)
  })
  description = "Optional S3 Object Lock default retention. Enabling Object Lock is an irreversible bucket capability."
  default     = {}

  validation {
    condition     = contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock.mode)
    error_message = "object_lock.mode must be GOVERNANCE or COMPLIANCE."
  }

  validation {
    condition     = var.object_lock.retention_days >= 1
    error_message = "object_lock.retention_days must be at least 1."
  }
}

variable "bucket_key_enabled" {
  type        = bool
  description = "Use an S3 Bucket Key when SSE-KMS is enabled."
  default     = true
}

variable "block_public_acls" {
  type        = bool
  description = "Block public ACLs."
  default     = true
}

variable "block_public_policy" {
  type        = bool
  description = "Block public bucket policies."
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  description = "Ignore public ACLs."
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  description = "Restrict public bucket policies."
  default     = true
}

variable "enforce_tls" {
  type        = bool
  description = "Attach a bucket policy that denies non-TLS requests."
  default     = true
}

variable "bucket_policy_json" {
  type        = string
  description = "Optional additional IAM policy document to merge with the TLS policy."
  default     = null

  validation {
    condition     = var.bucket_policy_json == null || can(jsondecode(var.bucket_policy_json))
    error_message = "bucket_policy_json must be null or valid JSON."
  }
}

variable "lifecycle_rules" {
  type = map(object({
    enabled                         = optional(bool, true)
    prefix                          = optional(string)
    expiration_days                 = optional(number)
    noncurrent_version_expiration   = optional(number)
    abort_incomplete_multipart_days = optional(number)
  }))
  description = "Lifecycle rules keyed by stable rule ID."
  default     = {}

  validation {
    condition = alltrue(flatten([
      for rule in values(var.lifecycle_rules) : [
        rule.expiration_days == null || rule.expiration_days >= 1,
        rule.noncurrent_version_expiration == null || rule.noncurrent_version_expiration >= 1,
        rule.abort_incomplete_multipart_days == null || rule.abort_incomplete_multipart_days >= 1
      ]
    ]))
    error_message = "Lifecycle day values must be null or at least 1."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Bucket-specific tags."
  default     = {}
}
