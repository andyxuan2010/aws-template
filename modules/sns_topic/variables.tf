variable "name" {
  type        = string
  description = "Explicit topic name. The module appends .fifo when required."
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
}

variable "display_name" {
  type        = string
  description = "Optional topic display name."
  default     = null
}

variable "fifo_topic" {
  type        = bool
  description = "Create a FIFO topic."
  default     = false
}

variable "content_based_deduplication" {
  type        = bool
  description = "Enable content-based deduplication for FIFO topics."
  default     = false
}

variable "fifo_throughput_scope" {
  type        = string
  description = "FIFO throughput scope."
  default     = null
}

variable "kms_master_key_id" {
  type        = string
  description = "Customer-managed KMS key ID or ARN."
}

variable "signature_version" {
  type        = number
  description = "SNS signature version."
  default     = 2

  validation {
    condition     = contains([1, 2], var.signature_version)
    error_message = "signature_version must be 1 or 2."
  }
}

variable "tracing_config" {
  type        = string
  description = "X-Ray tracing mode for standard topics."
  default     = "Active"
}

variable "archive_policy_json" {
  type        = string
  description = "Optional FIFO message archive policy JSON."
  default     = null
}

variable "topic_policy_json" {
  type        = string
  description = "Optional resource policy JSON."
  default     = null

  validation {
    condition     = var.topic_policy_json == null || can(jsondecode(var.topic_policy_json))
    error_message = "topic_policy_json must be null or valid JSON."
  }
}

variable "data_protection_policy_json" {
  type        = string
  description = "Optional SNS data-protection policy JSON."
  default     = null

  validation {
    condition     = var.data_protection_policy_json == null || can(jsondecode(var.data_protection_policy_json))
    error_message = "data_protection_policy_json must be null or valid JSON."
  }
}

variable "allow_insecure_http_subscriptions" {
  type        = bool
  description = "Allow plaintext HTTP subscription endpoints."
  default     = false
}

variable "subscriptions" {
  type = map(object({
    protocol                        = string
    endpoint                        = string
    endpoint_auto_confirms          = optional(bool, false)
    confirmation_timeout_in_minutes = optional(number, 1)
    raw_message_delivery            = optional(bool, false)
    filter_policy                   = optional(string)
    filter_policy_scope             = optional(string, "MessageAttributes")
    redrive_policy                  = optional(string)
    subscription_role_arn           = optional(string)
  }))
  description = "Topic subscriptions keyed by stable logical name."
  default     = {}

  validation {
    condition = alltrue([
      for subscription in values(var.subscriptions) :
      contains(["application", "email", "email-json", "firehose", "https", "http", "lambda", "sms", "sqs"], subscription.protocol) &&
      trimspace(subscription.endpoint) != "" &&
      (subscription.filter_policy == null || can(jsondecode(subscription.filter_policy))) &&
      (subscription.redrive_policy == null || can(jsondecode(subscription.redrive_policy)))
    ])
    error_message = "Subscriptions must use supported protocols, non-empty endpoints, and valid JSON policies."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Topic-specific tags."
  default     = {}
}
