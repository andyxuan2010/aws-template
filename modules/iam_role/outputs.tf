output "role_id" {
  description = "IAM role ID."
  value       = aws_iam_role.this.id
}

output "role_arn" {
  description = "IAM role ARN."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Resolved IAM role name."
  value       = aws_iam_role.this.name
}

output "instance_profile_arn" {
  description = "Instance profile ARN, or null when not created."
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}

output "instance_profile_name" {
  description = "Instance profile name, or null when not created."
  value       = try(aws_iam_instance_profile.this[0].name, null)
}
