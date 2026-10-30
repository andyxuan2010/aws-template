variable "standards_arns" {
  type        = set(string)
  description = "Explicit regional Security Hub standard ARNs to subscribe after CSPM is enabled."
  default     = []
}
variable "auto_enable_controls" {
  type        = bool
  description = "Automatically enable new controls in subscribed standards."
  default     = true

}
variable "aggregation_linking_mode" {
  type        = string
  description = "Optional finding aggregator mode; set only in the designated home Region."
  default     = null
  validation {
    condition     = var.aggregation_linking_mode == null || contains(["ALL_REGIONS", "SPECIFIED_REGIONS"], var.aggregation_linking_mode)
    error_message = "aggregation_linking_mode must be ALL_REGIONS, SPECIFIED_REGIONS, or null."
  }

}
variable "specified_regions" {
  type        = set(string)
  description = "Regions included by a SPECIFIED_REGIONS finding aggregator."
  default     = []

}
