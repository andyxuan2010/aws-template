variable "name" {
  type        = string
  description = "EKS cluster name; generated when empty."
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
variable "kubernetes_version" {
  type        = string
  description = "Explicit supported Kubernetes version."

}
variable "cluster_role_arn" {
  type        = string
  description = "Caller-managed EKS cluster IAM role ARN."

}
variable "admin_role_arn" {
  type        = string
  description = "IAM role ARN that receives EKS cluster-admin access."

}
variable "subnet_ids" {
  type        = set(string)
  description = "Private subnet IDs across at least two Availability Zones."
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two private subnets are required."
  }

}
variable "cluster_security_group_ids" {
  type        = set(string)
  description = "Optional additional cluster security group IDs."
  default     = []

}
variable "endpoint_public_access" {
  type        = bool
  description = "Enable the public Kubernetes API endpoint."
  default     = false

}
variable "endpoint_public_access_cidrs" {
  type        = set(string)
  description = "CIDRs allowed to reach the public endpoint; required and restricted when public access is enabled."
  default     = []

}
variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key ARN for Kubernetes secret encryption."
}
variable "node_groups" {
  description = "Managed node groups keyed by stable logical name."
  type = map(object({
    node_role_arn  = string
    subnet_ids     = optional(set(string))
    instance_types = set(string)
    capacity_type  = optional(string, "ON_DEMAND")
    min_size       = number
    desired_size   = number
    max_size       = number
    disk_size      = optional(number, 50)
  }))
  default = {}
}
variable "addons" {
  description = "EKS managed add-ons keyed by add-on name. Pin versions for controlled upgrades."
  type = map(object({
    addon_version = optional(string)
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
