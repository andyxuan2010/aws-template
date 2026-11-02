variable "name" {
  type        = string
  description = "Optional custom event bus name; empty uses the default bus."
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
    error_message = "environment is not supported."
  }
}
variable "instance" {
  type        = string
  description = "Three-digit instance."
  default     = "001"
}
variable "rules" {
  type = map(object({
    description         = optional(string),
    event_pattern       = optional(string),
    schedule_expression = optional(string),
    state               = optional(string, "ENABLED"),
    role_arn            = optional(string),
    targets             = optional(map(object({ arn = string, role_arn = optional(string), input = optional(string), input_path = optional(string), dead_letter_arn = optional(string), retry_policy = optional(object({ maximum_event_age_in_seconds = optional(number, 86400), maximum_retry_attempts = optional(number, 185) })) })), {})
  }))
  description = "Rules and targets keyed by stable logical names."
  default     = {}
  validation {
    condition     = alltrue([for r in values(var.rules) : (r.event_pattern == null) != (r.schedule_expression == null)])
    error_message = "Each rule must set exactly one of event_pattern or schedule_expression."
  }
}
variable "archive" {
  type        = object({ retention_days = optional(number, 0), event_pattern = optional(string) })
  description = "Optional custom-bus archive."
  default     = null
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "EventBridge-specific tags."
  default     = {}
}
