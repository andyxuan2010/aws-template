variable "name" {
  type        = string
  description = "Explicit instance name. When empty, the standard name is generated."
  default     = ""
}

variable "workload" {
  type        = string
  description = "Workload identifier."
  default     = "platform"
}

variable "region_code" {
  type        = string
  description = "Short AWS region code, for example use1."
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

variable "ami_id" {
  type        = string
  description = "Approved AMI ID. Resolve AMI selection in the root composition."

  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]{8,17}$", var.ami_id))
    error_message = "ami_id must be a valid AMI ID."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet in which to create the instance."

  validation {
    condition     = can(regex("^subnet-[0-9a-zA-Z]+$", var.subnet_id))
    error_message = "subnet_id must look like an AWS subnet ID."
  }
}

variable "security_group_ids" {
  type        = set(string)
  description = "VPC security groups attached to the primary network interface."

  validation {
    condition     = length(var.security_group_ids) > 0 && alltrue([for id in var.security_group_ids : can(regex("^sg-[0-9a-zA-Z]+$", id))])
    error_message = "security_group_ids must contain at least one valid security group ID."
  }
}

variable "iam_instance_profile_name" {
  type        = string
  description = "Optional IAM instance profile name."
  default     = null
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name. Prefer SSM Session Manager over SSH keys."
  default     = null
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public IPv4 address. Disabled by default."
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
  description = "Enable EBS optimization when supported by the instance type."
  default     = true
}

variable "metadata_options" {
  type = object({
    http_endpoint               = optional(string, "enabled")
    http_tokens                 = optional(string, "required")
    http_put_response_hop_limit = optional(number, 1)
    instance_metadata_tags      = optional(string, "disabled")
  })
  description = "Instance Metadata Service controls. IMDSv2 is required by default."
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
  description = "Root EBS volume configuration."
  default     = {}

  validation {
    condition     = var.root_block_device.volume_size >= 8
    error_message = "root_block_device.volume_size must be at least 8 GiB."
  }
}

variable "user_data" {
  type        = string
  description = "Optional bootstrap data. Do not include secrets because user data is stored in Terraform state and instance metadata."
  default     = null
  sensitive   = true
}

variable "user_data_replace_on_change" {
  type        = bool
  description = "Replace the instance when user data changes."
  default     = true
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags supplied by the root composition."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Instance-specific tags."
  default     = {}
}
