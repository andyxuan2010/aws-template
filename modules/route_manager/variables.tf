variable "name" {
  type        = string
  description = "Explicit route manager name. When empty, the standard name is generated."
  default     = ""

  validation {
    condition     = trimspace(var.name) == "" || can(regex("^[A-Za-z0-9-]{1,64}$", trimspace(var.name)))
    error_message = "name must be empty or use 1-64 letters, numbers, or hyphens."
  }
}

variable "workload" {
  type        = string
  description = "Workload identifier used in the generated name."
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

variable "routes" {
  type = map(object({
    route_table_id              = string
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
    target = object({
      type = string
      id   = string
    })
    failover = optional(object({
      active_target = optional(string, "primary")
      secondary_target = object({
        type = string
        id   = string
      })
    }))
  }))
  description = "Routes keyed by stable logical name. Targets may be FortiGate network interfaces, GWLB VPC endpoints, transit gateways, NAT gateways, or other supported AWS route targets."

  validation {
    condition = length(var.routes) > 0 && alltrue([
      for route in values(var.routes) :
      can(regex("^rtb-[0-9a-zA-Z]+$", route.route_table_id)) &&
      length(compact([
        try(route.destination_cidr_block, null),
        try(route.destination_ipv6_cidr_block, null)
      ])) == 1
    ])
    error_message = "Each route requires a valid route table ID and exactly one IPv4 or IPv6 destination CIDR."
  }

  validation {
    condition = alltrue(flatten([
      for route in values(var.routes) : [
        try(route.destination_cidr_block, null) == null || (
          !strcontains(route.destination_cidr_block, ":") && can(cidrhost(route.destination_cidr_block, 0))
        ),
        try(route.destination_ipv6_cidr_block, null) == null || (
          strcontains(route.destination_ipv6_cidr_block, ":") && can(cidrhost(route.destination_ipv6_cidr_block, 0))
        )
      ]
    ]))
    error_message = "Route destinations must be valid IPv4 or IPv6 CIDR blocks of the matching type."
  }

  validation {
    condition = alltrue(flatten([
      for route in values(var.routes) : [
        contains([
          "egress_only_gateway_id",
          "gateway_id",
          "nat_gateway_id",
          "network_interface_id",
          "transit_gateway_id",
          "vpc_endpoint_id",
          "vpc_peering_connection_id"
        ], route.target.type),
        trimspace(route.target.id) != "",
        try(route.failover == null, true) || contains(["primary", "secondary"], route.failover.active_target),
        try(route.failover == null, true) || contains([
          "egress_only_gateway_id",
          "gateway_id",
          "nat_gateway_id",
          "network_interface_id",
          "transit_gateway_id",
          "vpc_endpoint_id",
          "vpc_peering_connection_id"
        ], route.failover.secondary_target.type),
        try(route.failover == null, true) || trimspace(route.failover.secondary_target.id) != ""
      ]
    ]))
    error_message = "Routes and failover targets must use a supported AWS target type and non-empty ID."
  }
}
