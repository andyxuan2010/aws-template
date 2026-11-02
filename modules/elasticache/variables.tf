variable "name" {
  type        = string
  description = "Replication group identifier; generated when empty."
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
variable "engine" {
  type        = string
  description = "Cache engine: valkey or redis."
  default     = "valkey"
  validation {
    condition     = contains(["valkey", "redis"], var.engine)
    error_message = "engine must be valkey or redis."
  }

}
variable "engine_version" {
  type        = string
  description = "Explicit compatible engine version."

}
variable "node_type" {
  type        = string
  description = "ElastiCache node type."

}
variable "subnet_ids" {
  type        = set(string)
  description = "Private subnet IDs in distinct Availability Zones."
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two private subnets are required."
  }

}
variable "security_group_ids" {
  type        = set(string)
  description = "Caller-managed security group IDs."
  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group is required."
  }

}
variable "user_group_ids" {
  type        = set(string)
  description = "Caller-managed ElastiCache user group IDs for client authentication."
  validation {
    condition     = length(var.user_group_ids) > 0
    error_message = "At least one user group is required; provide ACL users without passing passwords through Terraform."
  }

}
variable "num_cache_clusters" {
  type        = number
  description = "Number of cache nodes for non-cluster mode."
  default     = 2
  validation {
    condition     = var.num_cache_clusters >= 2
    error_message = "At least two cache nodes are required for failover."
  }

}
variable "snapshot_retention_limit" {
  type        = number
  description = "Automatic backup retention days."
  default     = 7
  validation {
    condition     = var.snapshot_retention_limit >= 1 && var.snapshot_retention_limit <= 35
    error_message = "Snapshot retention must be between 1 and 35 days."
  }

}
variable "kms_key_id" {
  type        = string
  description = "Optional customer-managed KMS key ID or ARN."
  default     = null

}
variable "parameter_group_name" {
  type        = string
  description = "Optional compatible parameter group name."
  default     = null

}
variable "maintenance_window" {
  type        = string
  description = "Optional weekly maintenance window."
  default     = null

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
