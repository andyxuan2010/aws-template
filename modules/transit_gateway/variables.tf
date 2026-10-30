variable "workload" {
  type        = string
  description = "Workload or platform identifier used in resource Name tags."
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
  description = "Description for the transit gateway."
  default     = "Managed by Terraform"
}

variable "amazon_side_asn" {
  type        = number
  description = "Private autonomous system number for the AWS side of the transit gateway."
  default     = 64512

  validation {
    condition     = var.amazon_side_asn >= 64512 && var.amazon_side_asn <= 65534 || var.amazon_side_asn >= 4200000000 && var.amazon_side_asn <= 4294967294
    error_message = "amazon_side_asn must be in the private 16-bit or 32-bit ASN range."
  }
}

variable "route_tables" {
  type = map(object({
    description = optional(string)
    routes = optional(map(object({
      destination_cidr_block = string
      attachment_key         = string
    })), {})
    tags = optional(map(string), {})
  }))
  description = "Transit gateway route tables keyed by stable logical names. Static routes target attachment keys."

  validation {
    condition = alltrue(flatten([
      for route_table in values(var.route_tables) : [
        for route in values(route_table.routes) : can(cidrhost(route.destination_cidr_block, 0))
      ]
    ]))
    error_message = "Every static route destination_cidr_block must be a valid IPv4 or IPv6 CIDR block."
  }
}

variable "attachments" {
  type = map(object({
    vpc_id                      = string
    subnet_ids                  = set(string)
    route_table_key             = string
    dns_support                 = optional(string, "enable")
    ipv6_support                = optional(string, "disable")
    appliance_mode_support      = optional(string, "disable")
    propagated_route_table_keys = optional(set(string), [])
    tags                        = optional(map(string), {})
  }))
  description = "VPC attachments keyed by stable logical names. Select one subnet per intended Availability Zone."

  validation {
    condition = alltrue([
      for attachment in values(var.attachments) :
      length(attachment.subnet_ids) > 0 &&
      can(regex("^vpc-[a-zA-Z0-9]+$", attachment.vpc_id)) &&
      contains(["enable", "disable"], attachment.dns_support) &&
      contains(["enable", "disable"], attachment.ipv6_support) &&
      contains(["enable", "disable"], attachment.appliance_mode_support)
    ])
    error_message = "Each attachment needs a valid VPC ID, at least one subnet, and enable/disable values for all options."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Resource-specific tags applied to the transit gateway."
  default     = {}
}
