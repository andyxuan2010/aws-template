variable "name" {
  type        = string
  description = "Optional state machine name."
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
  description = "Three-digit instance."
  default     = "001"
}
variable "role_arn" {
  type        = string
  description = "Execution IAM role ARN."
}
variable "definition" {
  type        = string
  description = "Amazon States Language JSON."
  validation {
    condition     = can(jsondecode(var.definition))
    error_message = "definition must be valid JSON."
  }
}
variable "type" {
  type        = string
  description = "STANDARD or EXPRESS."
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "EXPRESS"], upper(var.type))
    error_message = "type must be STANDARD or EXPRESS."
  }
}
variable "log_destination" {
  type        = string
  description = "CloudWatch Logs destination ARN ending in :*."
  default     = null
}
variable "log_level" {
  type        = string
  description = "OFF, ERROR, ALL, or FATAL."
  default     = "ERROR"
}
variable "include_execution_data" {
  type        = bool
  description = "Include execution input/output in logs; may contain sensitive data."
  default     = false
}
variable "tracing_enabled" {
  type        = bool
  description = "Enable X-Ray tracing."
  default     = true
}
variable "publish" {
  type        = bool
  description = "Publish an immutable state-machine version."
  default     = false
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "State-machine tags."
  default     = {}
}
