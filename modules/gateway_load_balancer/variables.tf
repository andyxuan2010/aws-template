variable "name" {
  type        = string
  description = "Explicit Gateway Load Balancer name. When empty, the standard name is generated."
  default     = ""

  validation {
    condition     = trimspace(var.name) == "" || can(regex("^[A-Za-z0-9](?:[A-Za-z0-9-]{0,30}[A-Za-z0-9])?$", trimspace(var.name)))
    error_message = "name must be empty or a valid load balancer name up to 32 characters."
  }
}

variable "target_group_name" {
  type        = string
  description = "Optional GENEVE target group name. When empty, it is derived from the load balancer name."
  default     = ""

  validation {
    condition     = trimspace(var.target_group_name) == "" || can(regex("^[A-Za-z0-9](?:[A-Za-z0-9-]{0,30}[A-Za-z0-9])?$", trimspace(var.target_group_name)))
    error_message = "target_group_name must be empty or a valid target group name up to 32 characters."
  }
}

variable "workload" {
  type        = string
  description = "Workload identifier."
  default     = "network"
}

variable "region_code" {
  type        = string
  description = "Short AWS region code, for example use1."

  validation {
    condition     = can(regex("^[a-z0-9-]{2,12}$", trimspace(var.region_code)))
    error_message = "region_code must contain 2-12 lowercase letters, numbers, or hyphens."
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"

  validation {
    condition     = contains(["prod", "staging", "dev", "qa", "test", "sbx", "poc"], lower(trimspace(var.environment)))
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

variable "vpc_id" {
  type        = string
  description = "VPC containing the FortiGate target interfaces and Gateway Load Balancer."

  validation {
    condition     = can(regex("^vpc-[0-9a-zA-Z]+$", trimspace(var.vpc_id)))
    error_message = "vpc_id must look like an AWS VPC ID."
  }
}

variable "subnet_mappings" {
  type = map(object({
    availability_zone    = string
    subnet_id            = string
    private_ipv4_address = optional(string)
  }))
  description = "GWLB subnet mappings keyed by stable logical name. Use one subnet per Availability Zone; private IPv4 addresses are optional."

  validation {
    condition = length(var.subnet_mappings) > 0 && alltrue([
      for mapping in values(var.subnet_mappings) : can(regex("^subnet-[0-9a-zA-Z]+$", mapping.subnet_id)) && trimspace(mapping.availability_zone) != ""
    ])
    error_message = "subnet_mappings must contain at least one valid subnet and non-empty Availability Zone."
  }

  validation {
    condition     = length(distinct([for mapping in values(var.subnet_mappings) : mapping.availability_zone])) == length(var.subnet_mappings)
    error_message = "subnet_mappings must contain no more than one subnet per Availability Zone."
  }

  validation {
    condition = alltrue([
      for mapping in values(var.subnet_mappings) : try(mapping.private_ipv4_address, null) == null || can(cidrhost("${mapping.private_ipv4_address}/32", 0))
    ])
    error_message = "subnet_mappings.private_ipv4_address values must be valid IPv4 addresses."
  }
}

variable "targets" {
  type = map(object({
    availability_zone = string
    ip                = string
  }))
  description = "FortiGate traffic-interface IP targets keyed by stable logical name. Targets use GENEVE port 6081 and should normally be the FortiGate interface IPs configured for GWLB traffic."

  validation {
    condition = length(var.targets) > 0 && alltrue([
      for target in values(var.targets) : can(cidrhost("${trimspace(target.ip)}/32", 0)) && trimspace(target.availability_zone) != ""
    ])
    error_message = "targets must contain at least one valid private IPv4 address and non-empty Availability Zone."
  }
}

variable "health_check" {
  type = object({
    enabled             = optional(bool, true)
    protocol            = optional(string, "TCP")
    port                = optional(number, 443)
    path                = optional(string, "/")
    matcher             = optional(string, "200-399")
    interval            = optional(number, 30)
    timeout             = optional(number, 5)
    healthy_threshold   = optional(number, 3)
    unhealthy_threshold = optional(number, 3)
  })
  description = "FortiGate health check. TCP/443 is the default; HTTPS/443 with path can be selected when FortiOS probe-response is configured."
  default     = {}

  validation {
    condition = (
      contains(["TCP", "HTTP", "HTTPS"], upper(var.health_check.protocol)) &&
      (var.health_check.port == null || (var.health_check.port >= 1 && var.health_check.port <= 65535)) &&
      var.health_check.interval >= 5 && var.health_check.interval <= 300 &&
      var.health_check.timeout >= 2 && var.health_check.timeout <= 120 &&
      var.health_check.healthy_threshold >= 2 && var.health_check.healthy_threshold <= 10 &&
      var.health_check.unhealthy_threshold >= 2 && var.health_check.unhealthy_threshold <= 10
    )
    error_message = "health_check contains an invalid protocol, port, interval, timeout, or threshold."
  }

  validation {
    condition     = !contains(["HTTP", "HTTPS"], upper(var.health_check.protocol)) || trimspace(var.health_check.path) != ""
    error_message = "HTTP and HTTPS health checks require a non-empty path."
  }
}

variable "deregistration_delay" {
  type        = number
  description = "Seconds that the target group waits before deregistering a FortiGate target."
  default     = 300

  validation {
    condition     = var.deregistration_delay >= 0 && var.deregistration_delay <= 3600
    error_message = "deregistration_delay must be from 0 through 3600 seconds."
  }
}

variable "stickiness" {
  type = object({
    enabled = optional(bool, false)
    type    = optional(string, "source_ip_dest_ip_proto")
  })
  description = "Optional configurable GWLB flow stickiness. Disabled uses AWS's default 5-tuple flow stickiness."
  default     = {}

  validation {
    condition     = contains(["source_ip_dest_ip", "source_ip_dest_ip_proto"], var.stickiness.type)
    error_message = "stickiness.type must be source_ip_dest_ip or source_ip_dest_ip_proto."
  }
}

variable "target_failover" {
  type = object({
    on_deregistration = optional(string, "no_rebalance")
    on_unhealthy      = optional(string, "no_rebalance")
  })
  description = "GWLB target failover behavior for existing flows. Both settings must match."
  default     = {}

  validation {
    condition = (
      contains(["rebalance", "no_rebalance"], var.target_failover.on_deregistration) &&
      contains(["rebalance", "no_rebalance"], var.target_failover.on_unhealthy) &&
      var.target_failover.on_deregistration == var.target_failover.on_unhealthy
    )
    error_message = "target_failover values must be rebalance or no_rebalance and must match each other."
  }
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "Enable cross-zone load balancing. Recommended when FortiGate targets span Availability Zones."
  default     = true
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Protect the Gateway Load Balancer from API deletion."
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

check "target_zone_coverage" {
  assert {
    condition = alltrue([
      for availability_zone in local.availability_zones : contains([
        for target in values(var.targets) : target.availability_zone
      ], availability_zone)
    ])
    error_message = "Every Gateway Load Balancer Availability Zone must have at least one FortiGate target in the same Availability Zone."
  }
}
