variable "name" {
  type        = string
  description = "Explicit VPC name. When empty, the standard name is generated."
  default     = ""

  validation {
    condition     = var.name == "" || can(regex("^[a-z0-9][a-z0-9-]{0,62}$", var.name))
    error_message = "name must be empty or a lowercase, hyphenated name up to 63 characters."
  }
}

variable "workload" {
  type        = string
  description = "Workload or application identifier used in generated names."
  default     = "platform"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,19}$", var.workload))
    error_message = "workload must be 1-20 lowercase letters, digits, or hyphens."
  }
}

variable "region_code" {
  type        = string
  description = "Short region code, for example use1."

  validation {
    condition     = can(regex("^[a-z0-9]{2,8}$", var.region_code))
    error_message = "region_code must contain 2-8 lowercase letters or digits."
  }
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

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR assigned to the VPC."

  validation {
    condition     = can(cidrhost(var.cidr_block, 0)) && try(var.cidr_block == cidrsubnet(var.cidr_block, 0, 0), false)
    error_message = "cidr_block must be a valid network-aligned CIDR."
  }
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable Amazon-provided DNS resolution."
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames. Requires enable_dns_support."
  default     = true
}

variable "instance_tenancy" {
  type        = string
  description = "VPC instance tenancy."
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "instance_tenancy must be default or dedicated."
  }
}

variable "enable_internet_gateway" {
  type        = bool
  description = "Create and attach an internet gateway."
  default     = true
}

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  description = "Request an Amazon-provided /56 IPv6 CIDR for the VPC."
  default     = false
}

variable "nat_gateway_mode" {
  type        = string
  description = "NAT topology for private subnet IPv4 egress: none, single, or one gateway per Availability Zone."
  default     = "none"

  validation {
    condition     = contains(["none", "single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be none, single, or per_az."
  }
}

variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    public                  = optional(bool, false)
    map_public_ip_on_launch = optional(bool, false)
    ipv6_prefix_index       = optional(number)
    assign_ipv6_on_creation = optional(bool, false)
    tags                    = optional(map(string), {})
  }))
  description = "Subnets keyed by stable logical name. ipv6_prefix_index allocates a /64 from the VPC-generated /56."
  default     = {}

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      can(cidrhost(subnet.cidr_block, 0)) &&
      try(subnet.cidr_block == cidrsubnet(subnet.cidr_block, 0, 0), false)
    ])
    error_message = "Every subnet cidr_block must be a valid network-aligned CIDR."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      subnet.ipv6_prefix_index == null || (
        subnet.ipv6_prefix_index >= 0 &&
        subnet.ipv6_prefix_index <= 255 &&
        subnet.ipv6_prefix_index == floor(subnet.ipv6_prefix_index)
      )
    ])
    error_message = "ipv6_prefix_index must be null or an integer from 0 through 255."
  }
}

variable "flow_log" {
  type = object({
    enabled                  = optional(bool, false)
    destination_arn          = optional(string)
    destination_type         = optional(string, "cloud-watch-logs")
    iam_role_arn             = optional(string)
    traffic_type             = optional(string, "ALL")
    max_aggregation_interval = optional(number, 600)
    log_format               = optional(string)
  })
  description = "Optional VPC Flow Log configuration. The destination and IAM role are owned by the root security/logging composition."
  default     = {}

  validation {
    condition     = contains(["cloud-watch-logs", "s3", "kinesis-data-firehose"], var.flow_log.destination_type)
    error_message = "flow_log.destination_type must be cloud-watch-logs, s3, or kinesis-data-firehose."
  }

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log.traffic_type)
    error_message = "flow_log.traffic_type must be ACCEPT, REJECT, or ALL."
  }

  validation {
    condition     = contains([60, 600], var.flow_log.max_aggregation_interval)
    error_message = "flow_log.max_aggregation_interval must be 60 or 600 seconds."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "VPC-specific tags merged over inherited_tags."
  default     = {}
}
