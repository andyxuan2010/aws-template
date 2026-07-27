variable "name" {
  type        = string
  description = "Explicit DB identifier. When empty, the standard name is generated."
  default     = ""
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

variable "engine" {
  type        = string
  description = "RDS database engine."

  validation {
    condition     = contains(["postgres", "mysql", "mariadb", "oracle-ee", "oracle-se2", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web"], var.engine)
    error_message = "engine must be an RDS engine supported by this module."
  }
}

variable "engine_version" {
  type        = string
  description = "Pinned database engine version."
}

variable "instance_class" {
  type        = string
  description = "RDS DB instance class."
}

variable "allocated_storage" {
  type        = number
  description = "Initial allocated storage in GiB."
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "allocated_storage must be at least 20 GiB."
  }
}

variable "max_allocated_storage" {
  type        = number
  description = "Storage autoscaling ceiling in GiB. Zero disables autoscaling."
  default     = 100
}

variable "storage_type" {
  type        = string
  description = "RDS storage type."
  default     = "gp3"
}

variable "storage_encrypted" {
  type        = bool
  description = "Encrypt database storage."
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "Optional customer-managed KMS key ARN or ID."
  default     = null
}

variable "db_name" {
  type        = string
  description = "Optional initial database name."
  default     = null
}

variable "master_username" {
  type        = string
  description = "Master database username. The password is managed by RDS in Secrets Manager."
}

variable "manage_master_user_password" {
  type        = bool
  description = "Let RDS manage the master password in Secrets Manager."
  default     = true
}

variable "master_user_secret_kms_key_id" {
  type        = string
  description = "Optional KMS key for the RDS-managed master-user secret."
  default     = null
}

variable "port" {
  type        = number
  description = "Database listener port. Null uses the engine default."
  default     = null
}

variable "subnet_ids" {
  type        = set(string)
  description = "Private subnet IDs for the DB subnet group."

  validation {
    condition     = length(var.subnet_ids) >= 2 && alltrue([for id in var.subnet_ids : can(regex("^subnet-[0-9a-zA-Z]+$", id))])
    error_message = "subnet_ids must contain at least two valid subnet IDs."
  }
}

variable "vpc_security_group_ids" {
  type        = set(string)
  description = "Security groups controlling database access."

  validation {
    condition     = length(var.vpc_security_group_ids) > 0
    error_message = "At least one database security group is required."
  }
}

variable "multi_az" {
  type        = bool
  description = "Deploy a standby in another Availability Zone."
  default     = true
}

variable "publicly_accessible" {
  type        = bool
  description = "Expose the database publicly. Disabled and prohibited for production."
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Automated backup retention in days."
  default     = 35

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be from 1 through 35 days."
  }
}

variable "backup_window" {
  type        = string
  description = "Optional UTC backup window."
  default     = null
}

variable "maintenance_window" {
  type        = string
  description = "Optional UTC maintenance window."
  default     = null
}

variable "deletion_protection" {
  type        = bool
  description = "Protect the DB instance from deletion."
  default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Skip the final snapshot on deletion. Disabled by default."
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Apply eligible modifications immediately instead of in the maintenance window."
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Automatically install minor engine upgrades."
  default     = true
}

variable "allow_major_version_upgrade" {
  type        = bool
  description = "Allow major engine upgrades."
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  type        = set(string)
  description = "Engine-supported log types exported to CloudWatch Logs."
  default     = []
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Enable Performance Insights when supported by the selected engine and class."
  default     = false
}

variable "performance_insights_kms_key_id" {
  type        = string
  description = "Optional KMS key for Performance Insights."
  default     = null
}

variable "performance_insights_retention_period" {
  type        = number
  description = "Performance Insights retention in days."
  default     = 7
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Database-specific tags."
  default     = {}
}
