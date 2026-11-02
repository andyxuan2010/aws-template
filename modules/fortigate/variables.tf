variable "name" {
  type        = string
  description = "Explicit FortiGate name prefix. When empty, the standard name is generated."
  default     = ""

  validation {
    condition     = trimspace(var.name) == "" || can(regex("^[A-Za-z0-9-]{1,54}$", trimspace(var.name)))
    error_message = "name must be empty or use 1-54 letters, numbers, or hyphens."
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

variable "architecture" {
  type        = string
  description = "FortiGate deployment architecture: single or active-passive."
  default     = "single"

  validation {
    condition     = contains(["single", "active-passive"], lower(trimspace(var.architecture)))
    error_message = "architecture must be single or active-passive."
  }
}

variable "ami_id" {
  type        = string
  description = "Approved FortiGate AMI ID. Set this or image_lookup, but not both."
  default     = null
  nullable    = true

  validation {
    condition     = var.ami_id == null || can(regex("^ami-[0-9a-fA-F]{8,17}$", trimspace(var.ami_id)))
    error_message = "ami_id must be null or a valid AMI ID."
  }
}

variable "image_lookup" {
  type = object({
    owners      = list(string)
    most_recent = optional(bool, false)
    filters     = map(list(string))
  })
  description = "Optional region-local AMI lookup. Use an explicit ami_id for approved production image pinning."
  default     = null
  nullable    = true
}

variable "license_type" {
  type        = string
  description = "FortiGate licensing model represented by the selected AMI: byol or payg. Marketplace subscription and entitlements remain caller responsibilities."
  default     = "byol"

  validation {
    condition     = contains(["byol", "payg"], lower(trimspace(var.license_type)))
    error_message = "license_type must be byol or payg."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type supported by the selected FortiGate version and model."
  default     = "c5.xlarge"
}

variable "interfaces" {
  type = map(object({
    role                  = string
    subnet_id             = optional(string, "")
    subnet_ids            = optional(map(string), {})
    primary               = optional(bool, false)
    device_index          = number
    private_ip            = optional(string)
    private_ips           = optional(map(string), {})
    security_group_ids    = optional(set(string), [])
    enabled_architectures = optional(set(string), ["single", "active-passive"])
  }))
  description = "FortiGate interfaces keyed by logical name. Use device_index to preserve the intended FortiOS port mapping; active-passive nodes use subnet_ids and private_ips keyed by a and b."

  validation {
    condition     = length(var.interfaces) > 0
    error_message = "At least one FortiGate interface must be defined."
  }

  validation {
    condition = alltrue([
      for interface in values(var.interfaces) : contains(["external", "internal", "ha", "management", "other"], lower(trimspace(interface.role)))
    ])
    error_message = "Each interface role must be external, internal, ha, management, or other."
  }

  validation {
    condition = alltrue(flatten([
      for interface in values(var.interfaces) : [
        for architecture in interface.enabled_architectures : contains(["single", "active-passive"], lower(trimspace(architecture)))
      ]
    ]))
    error_message = "enabled_architectures may contain only single or active-passive."
  }

  validation {
    condition = alltrue(flatten([
      for interface in values(var.interfaces) : [
        for address in concat(
          compact([try(interface.private_ip, null)]),
          values(interface.private_ips)
        ) : can(cidrhost("${trimspace(address)}/32", 0))
      ]
    ]))
    error_message = "private_ip and private_ips values must contain valid IPv4 addresses."
  }
}

variable "security_group_ids" {
  type        = set(string)
  description = "Default security groups for interfaces that do not specify a per-interface override."

  validation {
    condition     = length(var.security_group_ids) > 0 && alltrue([for id in var.security_group_ids : can(regex("^sg-[0-9a-zA-Z]+$", id))])
    error_message = "security_group_ids must contain at least one valid security group ID."
  }
}

variable "bootstrap" {
  type = object({
    config           = optional(string, "")
    license_file     = optional(string, "")
    include_hostname = optional(bool, true)
  })
  description = "FortiOS cloud-init content. config is appended as CLI commands; license_file is a BYOL license file and is stored in Terraform state when supplied."
  default     = {}
  sensitive   = true
}

variable "ha" {
  type = object({
    group_id            = optional(number, 1)
    group_name          = optional(string, "fortigate-ha")
    heartbeat_interface = optional(string, "ha")
    heartbeat_priority  = optional(number, 100)
    primary_priority    = optional(number, 200)
    secondary_priority  = optional(number, 100)
    session_pickup      = optional(bool, true)
    unicast_hb          = optional(bool, true)
  })
  description = "Generated active-passive HA settings. Used only when architecture is active-passive."
  default     = {}
}

variable "iam_instance_profile_name" {
  type        = string
  description = "Optional IAM instance profile name attached to each FortiGate instance."
  default     = null
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name for emergency operating-system access."
  default     = null
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IPv4 address with the primary ENI. Disabled by default."
  default     = false
}

variable "allow_public_ip" {
  type        = bool
  description = "Explicit acknowledgement that a public IP is intended when associate_public_ip_address is true."
  default     = false
}

variable "monitoring" {
  type        = bool
  description = "Enable EC2 detailed monitoring."
  default     = true
}

variable "disable_api_termination" {
  type        = bool
  description = "Enable EC2 API termination protection."
  default     = true
}

variable "ebs_optimized" {
  type        = bool
  description = "Enable EBS optimization when supported by the selected instance type."
  default     = true
}

variable "user_data_replace_on_change" {
  type        = bool
  description = "Replace the instance when generated or supplied bootstrap content changes."
  default     = true
}

variable "metadata_options" {
  type = object({
    http_endpoint               = optional(string, "enabled")
    http_tokens                 = optional(string, "required")
    http_put_response_hop_limit = optional(number, 1)
    instance_metadata_tags      = optional(string, "disabled")
  })
  description = "EC2 Instance Metadata Service controls. IMDSv2 is required by default."
  default     = {}

  validation {
    condition     = contains(["enabled", "disabled"], var.metadata_options.http_endpoint) && contains(["required", "optional"], var.metadata_options.http_tokens)
    error_message = "metadata_options contains an invalid endpoint or token mode."
  }

  validation {
    condition     = var.metadata_options.http_put_response_hop_limit >= 1 && var.metadata_options.http_put_response_hop_limit <= 64
    error_message = "metadata_options.http_put_response_hop_limit must be from 1 through 64."
  }
}

variable "root_block_device" {
  type = object({
    volume_type           = optional(string, "gp3")
    volume_size           = optional(number, 20)
    iops                  = optional(number)
    throughput            = optional(number)
    encrypted             = optional(bool, true)
    kms_key_id            = optional(string)
    delete_on_termination = optional(bool, true)
  })
  description = "Encrypted root EBS volume configuration."
  default     = {}
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

check "ami_selection" {
  assert {
    condition     = (var.ami_id != null) != (var.image_lookup != null)
    error_message = "Set exactly one of ami_id or image_lookup."
  }
}

check "interface_topology" {
  assert {
    condition = (
      length(local.primary_interfaces) == 1 &&
      length(distinct([for interface in values(local.enabled_interfaces) : interface.device_index])) == length(local.enabled_interfaces) &&
      alltrue([for interface in values(local.enabled_interfaces) : interface.device_index >= 0]) &&
      try(local.primary_interface.device_index, -1) == 0 &&
      alltrue([for interface in values(local.enabled_interfaces) : !interface.primary || interface.device_index == 0])
    )
    error_message = "The selected architecture requires exactly one primary interface at device index 0 and unique non-negative device indexes."
  }
}

check "active_passive_topology" {
  assert {
    condition = local.architecture != "active-passive" || (
      contains(keys(local.enabled_interfaces), var.ha.heartbeat_interface) &&
      local.enabled_interfaces[var.ha.heartbeat_interface].device_index > 0 &&
      try(local.enabled_interfaces[var.ha.heartbeat_interface].private_ips.a, "") != "" &&
      try(local.enabled_interfaces[var.ha.heartbeat_interface].private_ips.b, "") != ""
    )
    error_message = "active-passive requires the configured heartbeat interface with a non-primary device index and private_ips.a/private_ips.b."
  }
}

check "interface_subnets" {
  assert {
    condition = alltrue([
      for value in values(local.node_interfaces) : trimspace(value.subnet_id) != ""
    ])
    error_message = "Every enabled interface on every FortiGate node requires subnet_id or the corresponding subnet_ids entry."
  }
}

check "license_bootstrap" {
  assert {
    condition     = lower(trimspace(var.license_type)) == "byol" || trimspace(var.bootstrap.license_file) == ""
    error_message = "bootstrap.license_file is only valid with license_type = byol."
  }
}
