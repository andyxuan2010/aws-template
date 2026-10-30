variable "vpc_id" {
  type        = string
  description = "VPC in which to create the endpoints."

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "vpc_id must look like an AWS VPC ID."
  }
}

variable "endpoints" {
  type = map(object({
    service_name        = string
    type                = optional(string, "Interface")
    subnet_ids          = optional(set(string), [])
    security_group_ids  = optional(set(string), [])
    route_table_ids     = optional(set(string), [])
    private_dns_enabled = optional(bool, true)
    policy              = optional(string)
    tags                = optional(map(string), {})
  }))
  description = "VPC endpoints keyed by stable logical names. Supports Interface and Gateway endpoints."

  validation {
    condition = alltrue([
      for endpoint in values(var.endpoints) : contains(["Interface", "Gateway"], endpoint.type)
    ])
    error_message = "Endpoint type must be Interface or Gateway."
  }
}

variable "workload" {
  type        = string
  description = "Workload or platform identifier used in endpoint Name tags."
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

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource-specific tags applied to all endpoints."
  default     = {}
}
