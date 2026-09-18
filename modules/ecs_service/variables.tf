variable "name" {
  type        = string
  description = "Explicit ECS service and task-family name. When empty, the standard name is generated."
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
}

variable "cluster_arn" {
  type        = string
  description = "ARN of an existing ECS cluster."
}

variable "container_definitions_json" {
  type        = string
  description = "ECS container definitions JSON. Use Secrets Manager or Parameter Store references instead of plaintext secrets."

  validation {
    condition     = can(jsondecode(var.container_definitions_json)) && can(tolist(jsondecode(var.container_definitions_json)))
    error_message = "container_definitions_json must be a valid JSON array."
  }
}

variable "task_cpu" {
  type        = number
  description = "Task CPU units."
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "Task memory in MiB."
  default     = 512
}

variable "execution_role_arn" {
  type        = string
  description = "Task execution role ARN."
}

variable "task_role_arn" {
  type        = string
  description = "Application task role ARN. Keep separate from the execution role."
  default     = null
}

variable "operating_system_family" {
  type        = string
  description = "Task operating system family."
  default     = "LINUX"
}

variable "cpu_architecture" {
  type        = string
  description = "Task CPU architecture."
  default     = "ARM64"

  validation {
    condition     = contains(["ARM64", "X86_64"], var.cpu_architecture)
    error_message = "cpu_architecture must be ARM64 or X86_64."
  }
}

variable "ephemeral_storage_gib" {
  type        = number
  description = "Fargate ephemeral storage in GiB. Null uses the service default."
  default     = null

  validation {
    condition     = var.ephemeral_storage_gib == null || (var.ephemeral_storage_gib >= 21 && var.ephemeral_storage_gib <= 200)
    error_message = "ephemeral_storage_gib must be null or from 21 through 200."
  }
}

variable "desired_count" {
  type        = number
  description = "Desired running task count."
  default     = 1

  validation {
    condition     = var.desired_count >= 0
    error_message = "desired_count cannot be negative."
  }
}

variable "platform_version" {
  type        = string
  description = "Fargate platform version."
  default     = "LATEST"
}

variable "subnet_ids" {
  type        = set(string)
  description = "Private subnets for task network interfaces."

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "At least one subnet is required."
  }
}

variable "security_group_ids" {
  type        = set(string)
  description = "Security groups attached to task network interfaces."

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group is required."
  }
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign public IPs to tasks."
  default     = false
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "Minimum healthy percentage during deployments."
  default     = 100
}

variable "deployment_maximum_percent" {
  type        = number
  description = "Maximum running percentage during deployments."
  default     = 200
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Load balancer health-check grace period."
  default     = 60
}

variable "enable_execute_command" {
  type        = bool
  description = "Enable ECS Exec. Disabled by default and should be governed and audited when enabled."
  default     = false
}

variable "enable_deployment_circuit_breaker" {
  type        = bool
  description = "Stop failed deployments."
  default     = true
}

variable "rollback_on_deployment_failure" {
  type        = bool
  description = "Roll back failed deployments."
  default     = true
}

variable "wait_for_steady_state" {
  type        = bool
  description = "Wait for the service to reach steady state."
  default     = true
}

variable "load_balancers" {
  type = map(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  description = "ALB/NLB target-group attachments keyed by stable logical name."
  default     = {}
}

variable "service_registry_arn" {
  type        = string
  description = "Optional Cloud Map service registry ARN."
  default     = null
}

variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Service-specific tags."
  default     = {}
}
