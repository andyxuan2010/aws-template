variable "name" {
  type        = string
  description = "Explicit IAM role name. When empty, the standard global-resource name is generated."
  default     = ""
}

variable "workload" {
  type        = string
  description = "Workload identifier."
  default     = "platform"
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
  description = "IAM role description."
  default     = "Managed by Terraform"
}

variable "path" {
  type        = string
  description = "IAM path for the role."
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$|^/$", var.path))
    error_message = "path must begin and end with a slash."
  }
}

variable "assume_role_policy_json" {
  type        = string
  description = "Advanced escape hatch for a complete IAM trust policy JSON document. Mutually exclusive with trust_policy_statements."
  default     = null

  validation {
    condition     = var.assume_role_policy_json == null || can(jsondecode(var.assume_role_policy_json))
    error_message = "assume_role_policy_json must be null or valid JSON."
  }
}

variable "trust_policy_statements" {
  type = list(object({
    sid     = optional(string)
    effect  = optional(string, "Allow")
    actions = set(string)
    principals = list(object({
      type        = string
      identifiers = set(string)
    }))
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = set(string)
    })), [])
  }))
  description = "Typed IAM trust-policy statements. Prefer this over raw JSON for validation and reviewability."
  default     = []

  validation {
    condition = alltrue([
      for statement in var.trust_policy_statements :
      contains(["Allow", "Deny"], statement.effect) &&
      length(statement.actions) > 0 &&
      length(statement.principals) > 0 &&
      alltrue([for principal in statement.principals : length(principal.identifiers) > 0])
    ])
    error_message = "Each trust statement needs a valid effect, at least one action, and at least one non-empty principal."
  }
}

variable "max_session_duration" {
  type        = number
  description = "Maximum role session duration in seconds."
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "permissions_boundary_arn" {
  type        = string
  description = "Optional permissions boundary policy ARN."
  default     = null
}

variable "managed_policy_arns" {
  type        = set(string)
  description = "Managed policy ARNs to attach."
  default     = []

  validation {
    condition = alltrue([
      for arn in var.managed_policy_arns :
      can(regex("^arn:(aws|aws-us-gov|aws-cn):iam::(aws|[0-9]{12}):policy/.+$", arn))
    ])
    error_message = "managed_policy_arns must contain valid AWS, GovCloud, or China IAM policy ARNs."
  }
}

variable "inline_policies" {
  type        = map(string)
  description = "Inline policy JSON documents keyed by policy name."
  default     = {}

  validation {
    condition     = alltrue([for document in values(var.inline_policies) : can(jsondecode(document))])
    error_message = "Every inline policy must be valid JSON."
  }

  validation {
    condition = alltrue([
      for name in keys(var.inline_policies) :
      can(regex("^[A-Za-z0-9+=,.@_-]{1,128}$", name))
    ])
    error_message = "Inline policy names must use IAM-supported characters and be 1-128 characters."
  }
}

variable "create_instance_profile" {
  type        = bool
  description = "Create an EC2 instance profile for the role."
  default     = false
}

variable "instance_profile_name" {
  type        = string
  description = "Optional instance profile name. Defaults to the role name."
  default     = ""
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Role-specific tags."
  default     = {}
}
