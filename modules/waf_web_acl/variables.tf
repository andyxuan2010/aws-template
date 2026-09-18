variable "name" {
  type        = string
  description = "Optional web ACL name."
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
variable "scope" {
  type        = string
  description = "REGIONAL or CLOUDFRONT scope."
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], upper(var.scope))
    error_message = "scope must be REGIONAL or CLOUDFRONT."
  }
}
variable "default_action" {
  type        = string
  description = "ALLOW or BLOCK unmatched traffic."
  default     = "ALLOW"
  validation {
    condition     = contains(["ALLOW", "BLOCK"], upper(var.default_action))
    error_message = "default_action must be ALLOW or BLOCK."
  }
}
variable "managed_rule_groups" {
  type        = map(object({ priority = number, vendor_name = optional(string, "AWS"), name = string, excluded_rules = optional(set(string), []), override_action = optional(string, "none") }))
  description = "Managed rule groups keyed by stable logical name."
  default     = { common = { priority = 10, name = "AWSManagedRulesCommonRuleSet" } }
}
variable "rate_based_rules" {
  type        = map(object({ priority = number, limit = number, aggregate_key_type = optional(string, "IP"), action = optional(string, "block") }))
  description = "Rate rules keyed by stable logical name."
  default     = {}
}
variable "resource_arns" {
  type        = set(string)
  description = "Regional resource ARNs to associate."
  default     = []
}
variable "cloudwatch_metrics_enabled" {
  type        = bool
  description = "Publish WAF metrics."
  default     = true
}
variable "sampled_requests_enabled" {
  type        = bool
  description = "Retain sampled requests."
  default     = true
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "Web ACL tags."
  default     = {}
}
