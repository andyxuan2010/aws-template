variable "workload" {
  type        = string
  description = "Workload or platform identifier used in the detector Name tag."
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

variable "enable" {
  type        = bool
  description = "Enable monitoring and finding feedback. Set false to suspend while retaining existing findings."
  default     = true
}

variable "finding_publishing_frequency" {
  type        = string
  description = "Frequency at which subsequent occurrences of findings are published."
  default     = "SIX_HOURS"

  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "finding_publishing_frequency must be FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS."
  }
}

variable "features" {
  type = map(object({
    status                   = optional(string, "ENABLED")
    additional_configuration = optional(map(string), {})
  }))
  description = "Opt-in GuardDuty protection features keyed by AWS feature name. Features are not enabled unless listed."
  default     = {}

  validation {
    condition = alltrue([
      for name, feature in var.features :
      contains([
        "S3_DATA_EVENTS",
        "EKS_AUDIT_LOGS",
        "EBS_MALWARE_PROTECTION",
        "RDS_LOGIN_EVENTS",
        "EKS_RUNTIME_MONITORING",
        "LAMBDA_NETWORK_LOGS",
        "RUNTIME_MONITORING",
        "AI_PROTECTION",
        "AI_ANALYST"
      ], name) &&
      contains(["ENABLED", "DISABLED"], feature.status) &&
      alltrue([
        for config_name, config_status in feature.additional_configuration :
        contains(["ENABLED", "DISABLED"], config_status) && (
          name == "EKS_RUNTIME_MONITORING" ? config_name == "EKS_ADDON_MANAGEMENT" :
          name == "RUNTIME_MONITORING" ? contains([
            "EKS_ADDON_MANAGEMENT",
            "ECS_FARGATE_AGENT_MANAGEMENT",
            "EC2_AGENT_MANAGEMENT"
          ], config_name) : false
        )
      ])
    ]) && !(contains(keys(var.features), "EKS_RUNTIME_MONITORING") && contains(keys(var.features), "RUNTIME_MONITORING"))
    error_message = "features must use supported AWS feature names and statuses; additional configuration is only valid for runtime monitoring, and EKS_RUNTIME_MONITORING cannot be combined with RUNTIME_MONITORING."
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
