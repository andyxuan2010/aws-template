variable "name" {
  type        = string
  description = "Explicit queue name. The module appends .fifo when required."
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

variable "fifo_queue" {
  type        = bool
  description = "Create a FIFO queue."
  default     = false
}

variable "content_based_deduplication" {
  type        = bool
  description = "Enable content-based deduplication for FIFO queues."
  default     = false
}

variable "deduplication_scope" {
  type        = string
  description = "FIFO deduplication scope."
  default     = null
}

variable "fifo_throughput_limit" {
  type        = string
  description = "FIFO throughput quota mode."
  default     = null
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Message visibility timeout."
  default     = 30

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "visibility_timeout_seconds must be from 0 through 43200."
  }
}

variable "message_retention_seconds" {
  type        = number
  description = "Message retention period."
  default     = 345600

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be from 60 through 1209600."
  }
}

variable "max_message_size" {
  type        = number
  description = "Maximum message size in bytes."
  default     = 262144
}

variable "delay_seconds" {
  type        = number
  description = "Default delivery delay."
  default     = 0
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "Long-poll wait time."
  default     = 20

  validation {
    condition     = var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20
    error_message = "receive_wait_time_seconds must be from 0 through 20."
  }
}

variable "kms_key_id" {
  type        = string
  description = "Optional customer-managed KMS key ID or ARN. SQS-managed encryption is used when null."
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  type        = number
  description = "KMS data-key reuse period."
  default     = 300
}

variable "dead_letter_queue" {
  type = object({
    arn               = string
    max_receive_count = optional(number, 5)
  })
  description = "Optional dead-letter queue configuration."
  default     = null

  validation {
    condition     = var.dead_letter_queue == null || var.dead_letter_queue.max_receive_count >= 1
    error_message = "dead_letter_queue.max_receive_count must be at least 1."
  }
}

variable "queue_policy_json" {
  type        = string
  description = "Optional queue resource policy JSON."
  default     = null

  validation {
    condition     = var.queue_policy_json == null || can(jsondecode(var.queue_policy_json))
    error_message = "queue_policy_json must be null or valid JSON."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Queue-specific tags."
  default     = {}
}
