variable "name" {
  type        = string
  description = "Distribution label and generated comment."

}
variable "origins" {
  description = "Origin definitions keyed by stable logical ID. S3 origins get a private OAC; caller owns the bucket policy."
  type = map(object({
    domain_name            = string
    s3                     = optional(bool, false)
    origin_path            = optional(string)
    origin_protocol_policy = optional(string, "https-only")
    http_port              = optional(number, 80)
    https_port             = optional(number, 443)
  }))
  validation {
    condition     = length(var.origins) > 0 && alltrue([for origin in values(var.origins) : contains(["https-only", "match-viewer"], origin.origin_protocol_policy)])
    error_message = "Provide at least one origin and use HTTPS-only or match-viewer for custom origins."

  }
}
variable "default_origin_id" {
  type        = string
  description = "Key of the origin used by the default behavior."

}
variable "cache_policy_id" {
  type        = string
  description = "AWS or customer-managed CloudFront cache policy ID."

}
variable "aliases" {
  type        = set(string)
  description = "Optional alternate domain names."
  default     = []

}
variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN in us-east-1 for aliases."
  default     = null

}
variable "web_acl_id" {
  type        = string
  description = "Optional AWS WAFv2 web ACL ARN in the CloudFront scope."
  default     = null

}
variable "price_class" {
  type        = string
  description = "CloudFront price class."
  default     = "PriceClass_100"
  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "Unsupported CloudFront price class."
  }

}
variable "default_root_object" {
  type        = string
  description = "Optional root object, such as index.html."
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
