variable "name" {
  type        = string
  description = "Explicit key name used for the alias and Name tag. When empty, the standard name is generated."
  default     = ""
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

variable "description" {
  type        = string
  description = "KMS key description."
  default     = "Customer-managed key managed by Terraform"
}

variable "key_policy_json" {
  type        = string
  description = "Optional KMS key policy JSON. AWS applies its default policy when null."
  default     = null

  validation {
    condition     = var.key_policy_json == null || can(jsondecode(var.key_policy_json))
    error_message = "key_policy_json must be null or valid JSON."
  }
}

variable "key_usage" {
  type        = string
  description = "Intended cryptographic use."
  default     = "ENCRYPT_DECRYPT"

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
    error_message = "key_usage must be ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC."
  }
}

variable "customer_master_key_spec" {
  type        = string
  description = "KMS key material specification."
  default     = "SYMMETRIC_DEFAULT"

  validation {
    condition = contains([
      "SYMMETRIC_DEFAULT",
      "RSA_2048",
      "RSA_3072",
      "RSA_4096",
      "ECC_NIST_P256",
      "ECC_NIST_P384",
      "ECC_NIST_P521",
      "ECC_SECG_P256K1",
      "HMAC_224",
      "HMAC_256",
      "HMAC_384",
      "HMAC_512"
    ], var.customer_master_key_spec)
    error_message = "customer_master_key_spec is not a supported KMS key specification."
  }
}

variable "enable_key_rotation" {
  type        = bool
  description = "Enable automatic key rotation."
  default     = true
}

variable "multi_region" {
  type        = bool
  description = "Create a multi-Region primary key."
  default     = false
}

variable "deletion_window_in_days" {
  type        = number
  description = "Waiting period before scheduled key deletion."
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30."
  }
}

variable "is_enabled" {
  type        = bool
  description = "Whether the KMS key is enabled."
  default     = true
}

variable "enable_alias" {
  type        = bool
  description = "Create an alias for the key."
  default     = true
}

variable "grants" {
  type = map(object({
    grantee_principal  = string
    operations         = set(string)
    retiring_principal = optional(string)
    constraints = optional(object({
      encryption_context_equals = optional(map(string))
      encryption_context_subset = optional(map(string))
    }))
  }))
  description = "KMS grants keyed by stable grant name."
  default     = {}

  validation {
    condition = alltrue([
      for grant in values(var.grants) :
      length(grant.operations) > 0 && alltrue([
        for operation in grant.operations : contains([
          "Decrypt",
          "Encrypt",
          "GenerateDataKey",
          "GenerateDataKeyWithoutPlaintext",
          "ReEncryptFrom",
          "ReEncryptTo",
          "Sign",
          "Verify",
          "GenerateMac",
          "VerifyMac",
          "CreateGrant",
          "DescribeKey",
          "RetireGrant"
        ], operation)
      ])
    ])
    error_message = "Each KMS grant must contain supported operations."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Key-specific tags."
  default     = {}
}
