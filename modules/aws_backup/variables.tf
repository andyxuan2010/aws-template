variable "name" {
  type        = string
  description = "Optional backup plan and vault base name."
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
  description = "Three-digit instance."
  default     = "001"
}
variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key ARN for the vault."
}
variable "force_destroy" {
  type        = bool
  description = "Delete recovery points when destroying the vault."
  default     = false
}
variable "lock_configuration" {
  type        = object({ min_retention_days = number, max_retention_days = optional(number), changeable_for_days = optional(number) })
  description = "Optional Backup Vault Lock configuration."
  default     = null
}
variable "rules" {
  type        = map(object({ schedule = optional(string, "cron(0 5 ? * * *)"), start_window = optional(number, 60), completion_window = optional(number, 180), enable_continuous_backup = optional(bool, false), lifecycle = optional(object({ cold_storage_after = optional(number), delete_after = number })), copy_actions = optional(list(object({ destination_vault_arn = string, lifecycle = optional(object({ cold_storage_after = optional(number), delete_after = number })) })), []) }))
  description = "Backup rules keyed by stable logical name."
  default     = { daily = { lifecycle = { delete_after = 35 } } }
}
variable "selections" {
  type = map(object({ iam_role_arn = string, resources = optional(set(string), []), not_resources = optional(set(string), []), conditions = optional(list(object({ type = string, key = string
  value = string })), []) }))
  description = "Backup selections keyed by stable logical name."
  default     = {}
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "Backup-specific tags."
  default     = {}
}
