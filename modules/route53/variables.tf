variable "zone_name" {
  type        = string
  description = "DNS name of the hosted zone."
  validation {
    condition     = can(regex("^[A-Za-z0-9.-]+\\.?$", var.zone_name))
    error_message = "zone_name must be a valid DNS name."

  }
}
variable "comment" {
  type        = string
  description = "Hosted-zone comment."
  default     = "Managed by Terraform"
}
variable "force_destroy" {
  type        = bool
  description = "Delete non-default records with the zone."
  default     = false
}
variable "private_zone" {
  type        = bool
  description = "Create a private hosted zone."
  default     = false
}
variable "vpc_associations" {
  type = map(object({
    vpc_id     = string,
    vpc_region = optional(string)
  }))
  description = "VPC associations keyed by stable logical name. At least one is required for private zones."
  default     = {}
}
variable "records" {
  type = map(object({
    name            = string
    type            = string
    ttl             = optional(number, 300)
    records         = optional(list(string), [])
    allow_overwrite = optional(bool, false)
    set_identifier  = optional(string)
    health_check_id = optional(string)
    alias = optional(object({
      name                   = string,
      zone_id                = string,
      evaluate_target_health = optional(bool, false)
    }))
    weighted_routing_policy = optional(object({
      weight = number
    }))

  }))
  description = "DNS records keyed by stable logical name."
  default     = {}
  validation {
    condition     = alltrue([for record in values(var.records) : (record.alias == null) != (length(record.records) == 0)])
    error_message = "Each record must configure exactly one of alias or records."

  }
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "Hosted-zone-specific tags."
  default     = {}
}
