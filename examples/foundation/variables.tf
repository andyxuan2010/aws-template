variable "aws_region" {
  type        = string
  description = "AWS region for the example."
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name."
}

variable "offline_plan" {
  type        = bool
  description = "Disable AWS provider API validation for credential-free CI planning. Do not enable for deployment."
  default     = false
}
