variable "name" {
  type        = string
  description = "Explicit ALB name. When empty, a 32-character-safe standard name is generated."
  default     = ""

  validation {
    condition     = var.name == "" || can(regex("^[A-Za-z0-9](?:[A-Za-z0-9-]{0,30}[A-Za-z0-9])?$", var.name))
    error_message = "name must be empty or a valid ALB name up to 32 characters."
  }
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
  description = "Three-digit resource instance."
  default     = "001"

  validation {
    condition     = can(regex("^[0-9]{3}$", var.instance))
    error_message = "instance must be a three-digit string."
  }
}

variable "internal" {
  type        = bool
  description = "Create an internal ALB. Internet-facing load balancers require explicit opt-in."
  default     = true
}

variable "subnet_ids" {
  type        = set(string)
  description = "Subnet IDs spanning at least two Availability Zones."

  validation {
    condition     = length(var.subnet_ids) >= 2 && alltrue([for id in var.subnet_ids : can(regex("^subnet-[0-9a-zA-Z]+$", id))])
    error_message = "subnet_ids must contain at least two valid subnet IDs."
  }
}

variable "security_group_ids" {
  type        = set(string)
  description = "Security groups attached to the ALB."

  validation {
    condition     = length(var.security_group_ids) > 0 && alltrue([for id in var.security_group_ids : can(regex("^sg-[0-9a-zA-Z]+$", id))])
    error_message = "security_group_ids must contain at least one valid security group ID."
  }
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Protect the ALB from API deletion."
  default     = true
}

variable "drop_invalid_header_fields" {
  type        = bool
  description = "Drop HTTP headers with invalid fields."
  default     = true
}

variable "enable_http2" {
  type        = bool
  description = "Enable HTTP/2."
  default     = true
}

variable "idle_timeout" {
  type        = number
  description = "Idle timeout in seconds."
  default     = 60

  validation {
    condition     = var.idle_timeout >= 1 && var.idle_timeout <= 4000
    error_message = "idle_timeout must be from 1 through 4000 seconds."
  }
}

variable "access_logs" {
  type = object({
    bucket = string
    prefix = optional(string)
  })
  description = "Optional S3 access-log destination."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "VPC containing the target groups."
}

variable "target_groups" {
  type = map(object({
    port                 = number
    protocol             = optional(string, "HTTP")
    protocol_version     = optional(string, "HTTP1")
    target_type          = optional(string, "instance")
    deregistration_delay = optional(number, 300)
    health_check = optional(object({
      enabled             = optional(bool, true)
      path                = optional(string, "/")
      port                = optional(string, "traffic-port")
      protocol            = optional(string, "HTTP")
      matcher             = optional(string, "200-399")
      interval            = optional(number, 30)
      timeout             = optional(number, 5)
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
    }), {})
    tags = optional(map(string), {})
  }))
  description = "Target groups keyed by stable logical name."

  validation {
    condition     = length(var.target_groups) > 0 && alltrue([for value in values(var.target_groups) : value.port >= 1 && value.port <= 65535])
    error_message = "At least one target group is required and ports must be valid."
  }
}

variable "listeners" {
  type = map(object({
    port                       = number
    protocol                   = string
    target_group_key           = string
    certificate_arn            = optional(string)
    ssl_policy                 = optional(string, "ELBSecurityPolicy-TLS13-1-2-2021-06")
    mutual_authentication_mode = optional(string, "off")
    trust_store_arn            = optional(string)
  }))
  description = "Listeners keyed by stable logical name. HTTPS listeners require a certificate."

  validation {
    condition = length(var.listeners) > 0 && alltrue([
      for listener in values(var.listeners) :
      listener.port >= 1 &&
      listener.port <= 65535 &&
      contains(["HTTP", "HTTPS"], listener.protocol) &&
      contains(keys(var.target_groups), listener.target_group_key) &&
      (listener.protocol != "HTTPS" || listener.certificate_arn != null)
    ])
    error_message = "Listeners require valid ports, protocols, target_group_key values, and certificates for HTTPS."
  }
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "ALB-specific tags."
  default     = {}
}
