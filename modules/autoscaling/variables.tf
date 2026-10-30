variable "name" {
  type        = string
  description = "Explicit Auto Scaling group name; generated when empty."
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

  validation {
    condition     = contains(["prod", "staging", "dev", "qa", "test", "sbx", "poc"], var.environment)
    error_message = "environment is not supported."
  }
}
variable "instance" {
  type        = string
  description = "Three-digit resource instance."
  default     = "001"

}
variable "image_id" {
  type        = string
  description = "Approved AMI ID."

}
variable "instance_type" {
  type        = string
  description = "EC2 instance type."

}
variable "instance_profile_arn" {
  type        = string
  description = "Caller-managed instance profile ARN."

}
variable "subnet_ids" {
  type        = set(string)
  description = "Private subnet IDs spanning the desired Availability Zones."
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two private subnets are required for resilient capacity."

  }
}
variable "security_group_ids" {
  type        = set(string)
  description = "Security groups to attach to instances."
  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group is required."

  }
}
variable "min_size" {
  type        = number
  description = "Minimum group capacity."
  default     = 2

}
variable "desired_capacity" {
  type        = number
  description = "Initial desired group capacity."
  default     = 2

}
variable "max_size" {
  type        = number
  description = "Maximum group capacity."
  default     = 4

}
variable "target_group_arns" {
  type        = set(string)
  description = "Optional load balancer target groups."
  default     = []

}
variable "user_data_base64" {
  type        = string
  description = "Optional base64-encoded bootstrap script. Do not include secrets."
  default     = null
  sensitive   = true

}
variable "root_volume_size" {
  type        = number
  description = "Encrypted root volume size in GiB."
  default     = 30

}
variable "root_volume_type" {
  type        = string
  description = "Root EBS volume type."
  default     = "gp3"

}
variable "kms_key_arn" {
  type        = string
  description = "Optional customer-managed KMS key ARN for root EBS encryption."
  default     = null

}
variable "health_check_type" {
  type        = string
  description = "ASG health check type."
  default     = "EC2"
  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "health_check_type must be EC2 or ELB."
  }

}
variable "health_check_grace_period" {
  type        = number
  description = "Health check grace period in seconds."
  default     = 300

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
