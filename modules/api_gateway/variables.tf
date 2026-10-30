variable "name" {
  type        = string
  description = "Optional API name."
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
variable "protocol_type" {
  type        = string
  description = "HTTP or WEBSOCKET protocol."
  default     = "HTTP"
  validation {
    condition     = contains(["HTTP", "WEBSOCKET"], upper(var.protocol_type))
    error_message = "protocol_type must be HTTP or WEBSOCKET."
  }
}
variable "cors_configuration" {
  type        = object({ allow_credentials = optional(bool, false), allow_headers = optional(set(string), []), allow_methods = optional(set(string), []), allow_origins = set(string), expose_headers = optional(set(string), []), max_age = optional(number) })
  description = "Optional HTTP API CORS policy."
  default     = null
}
variable "integrations" {
  type        = map(object({ integration_type = optional(string, "AWS_PROXY"), integration_uri = string, integration_method = optional(string, "POST"), payload_format_version = optional(string, "2.0"), timeout_milliseconds = optional(number, 30000), connection_type = optional(string, "INTERNET"), connection_id = optional(string) }))
  description = "Integrations keyed by stable logical name."
  default     = {}
}
variable "routes" {
  type        = map(object({ route_key = string, integration_key = string, authorization_type = optional(string, "NONE"), authorizer_id = optional(string), authorization_scopes = optional(set(string), []), api_key_required = optional(bool, false) }))
  description = "Routes keyed by stable logical name."
  default     = {}
}
variable "stage_name" {
  type        = string
  description = "Deployment stage name."
  default     = "$default"
}
variable "auto_deploy" {
  type        = bool
  description = "Automatically deploy stage changes."
  default     = true
}
variable "access_log_destination_arn" {
  type        = string
  description = "CloudWatch Logs destination ARN."
  default     = null
}
variable "access_log_format" {
  type        = string
  description = "Access log JSON format."
  default     = "{\"requestId\":\"$context.requestId\",\"ip\":\"$context.identity.sourceIp\",\"requestTime\":\"$context.requestTime\",\"routeKey\":\"$context.routeKey\",\"status\":\"$context.status\",\"responseLength\":\"$context.responseLength\"}"
}
variable "disable_execute_api_endpoint" {
  type        = bool
  description = "Disable the default execute-api endpoint."
  default     = false
}
variable "inherited_tags" {
  type        = map(string)
  description = "Canonical enterprise tags."
  default     = {}
}
variable "tags" {
  type        = map(string)
  description = "API-specific tags."
  default     = {}
}
