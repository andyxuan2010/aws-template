variable "name" {
  type        = string
  description = "EFS file system name; generated when empty."
  default     = ""

}
variable "workload" {
  type        = string
  description = "Workload identifier."
  default     = "platform"

}
variable "region_code" {
  type        = string
  description = "Short AWS Region code."

}
variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"

}
variable "instance" {
  type        = string
  description = "Three-digit resource instance."
  default     = "001"

}
variable "subnet_ids" {
  type        = map(string)
  description = "Mount target subnet IDs keyed by stable AZ label; use one subnet per AZ."
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two mount target subnets are required for multi-AZ access."
  }

}
variable "security_group_ids" {
  type        = set(string)
  description = "Security groups allowing NFS only from approved clients."
  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one mount target security group is required."
  }

}
variable "kms_key_id" {
  type        = string
  description = "Optional customer-managed KMS key ID or ARN."
  default     = null

}
variable "throughput_mode" {
  type        = string
  description = "EFS throughput mode."
  default     = "elastic"
  validation {
    condition     = contains(["elastic", "bursting", "provisioned"], var.throughput_mode)
    error_message = "Unsupported EFS throughput mode."
  }

}
variable "provisioned_throughput_in_mibps" {
  type        = number
  description = "Provisioned throughput when throughput_mode is provisioned."
  default     = null

}
variable "transition_to_ia" {
  type        = string
  description = "Optional lifecycle transition to IA, such as AFTER_30_DAYS."
  default     = "AFTER_30_DAYS"

}
variable "access_points" {
  description = "Optional access points keyed by stable logical name."
  type = map(object({
    path          = string
    owner_uid     = number
    owner_gid     = number
    creation_uid  = number
    creation_gid  = number
    creation_mode = optional(string, "0750")
  }))
  default = {}
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}

}
variable "tags" {
  type        = map(string)
  description = "Resource-specific tags."
  default     = {}

}
