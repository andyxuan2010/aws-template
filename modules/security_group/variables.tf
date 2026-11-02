variable "name" {
  type        = string
  description = "Explicit security group name. When empty, the standard name is generated."
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
  description = "Security group description."
  default     = "Managed by Terraform"
}

variable "allow_public_ingress" {
  type        = bool
  description = "Explicitly allow ingress rules sourced from all IPv4 or IPv6 addresses."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "VPC in which to create the security group."

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "vpc_id must look like an AWS VPC ID."
  }

}

variable "ingress_rules" {
  type = map(object({
    description                  = optional(string)
    ip_protocol                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
  }))
  description = "Ingress rules keyed by a stable logical name."
  default     = {}

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      length(compact([
        try(rule.cidr_ipv4, null),
        try(rule.cidr_ipv6, null),
        try(rule.prefix_list_id, null),
        try(rule.referenced_security_group_id, null)
      ])) == 1
    ])
    error_message = "Each ingress rule must set exactly one source."
  }

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      rule.ip_protocol == "-1" ? (
        rule.from_port == null && rule.to_port == null
        ) : (
        rule.from_port != null &&
        rule.to_port != null &&
        rule.from_port >= 0 &&
        rule.to_port <= 65535 &&
        rule.from_port <= rule.to_port
      )
    ])
    error_message = "Ingress TCP, UDP, and protocol-specific rules must define a valid from_port and to_port range; protocol -1 must omit ports."
  }
}

variable "egress_rules" {
  type = map(object({
    description                  = optional(string)
    ip_protocol                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
  }))
  description = "Egress rules keyed by a stable logical name."
  default     = {}

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      length(compact([
        try(rule.cidr_ipv4, null),
        try(rule.cidr_ipv6, null),
        try(rule.prefix_list_id, null),
        try(rule.referenced_security_group_id, null)
      ])) == 1
    ])
    error_message = "Each egress rule must set exactly one destination."
  }

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      rule.ip_protocol == "-1" ? (
        rule.from_port == null && rule.to_port == null
        ) : (
        rule.from_port != null &&
        rule.to_port != null &&
        rule.from_port >= 0 &&
        rule.to_port <= 65535 &&
        rule.from_port <= rule.to_port
      )
    ])
    error_message = "Egress TCP, UDP, and protocol-specific rules must define a valid from_port and to_port range; protocol -1 must omit ports."
  }
}

variable "revoke_rules_on_delete" {
  type        = bool
  description = "Revoke attached rules before deleting the security group."
  default     = true
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
