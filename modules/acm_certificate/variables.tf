variable "domain_name" {
  type        = string
  description = "Primary certificate DNS name."
}
variable "subject_alternative_names" {
  type        = set(string)
  description = "Additional certificate DNS names."
  default     = []
}
variable "validation_method" {
  type        = string
  description = "Certificate validation method."
  default     = "DNS"
  validation {
    condition     = contains(["DNS", "EMAIL"], upper(var.validation_method))
    error_message = "validation_method must be DNS or EMAIL."
  }
}
variable "hosted_zone_id" {
  type        = string
  description = "Route 53 zone ID used to create DNS validation records."
  default     = null
}
variable "wait_for_validation" {
  type        = bool
  description = "Wait for ACM certificate validation."
  default     = true
}
variable "validation_record_ttl" {
  type        = number
  description = "DNS validation record TTL."
  default     = 60
}
variable "key_algorithm" {
  type        = string
  description = "Certificate key algorithm."
  default     = "RSA_2048"
  validation {
    condition     = contains(["RSA_2048", "EC_prime256v1", "EC_secp384r1"], var.key_algorithm)
    error_message = "key_algorithm is unsupported."
  }
}
variable "certificate_transparency_logging_preference" {
  type        = string
  description = "Certificate Transparency logging preference."
  default     = "ENABLED"
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "Certificate-specific tags."
  default     = {}
}
