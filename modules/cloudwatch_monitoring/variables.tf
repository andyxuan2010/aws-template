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
  description = "Three-digit instance."
  default     = "001"
  validation {
    condition     = can(regex("^[0-9]{3}$", var.instance))
    error_message = "instance must be three digits."
  }
}
variable "log_groups" {
  type = map(object({
    name              = optional(string),
    retention_in_days = optional(number, 365),
    kms_key_id        = optional(string),
    skip_destroy      = optional(bool, false),
    tags              = optional(map(string), {})
  }))
  description = "Log groups keyed by stable logical name."
  default     = {}
}
variable "metric_alarms" {
  type = map(object({
    alarm_name          = optional(string),
    comparison_operator = string,
    evaluation_periods  = number,
    threshold           = number,
    metric_name         = string,
    namespace           = string,
    period              = optional(number, 300),
    statistic           = optional(string, "Average"),
    dimensions          = optional(map(string), {}),
    alarm_actions       = optional(list(string), []),
    ok_actions          = optional(list(string), []),
    treat_missing_data  = optional(string, "missing")
    description         = optional(string),
    tags                = optional(map(string), {})
  }))
  description = "Metric alarms keyed by stable logical name."
  default     = {}
}
variable "dashboard_body" {
  type        = string
  description = "Optional CloudWatch dashboard JSON."
  default     = null
  validation {
    condition     = var.dashboard_body == null || can(jsondecode(var.dashboard_body))
    error_message = "dashboard_body must be valid JSON."
  }
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "Monitoring tags."
  default     = {}
}
