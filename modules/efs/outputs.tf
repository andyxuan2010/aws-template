output "file_system_id" {
  description = "EFS file system ID."
  value       = aws_efs_file_system.this.id
}
output "file_system_arn" {
  description = "EFS file system ARN."
  value       = aws_efs_file_system.this.arn
}
output "mount_target_ids" {
  description = "Mount target IDs keyed by subnet label."
  value = { for key, target in aws_efs_mount_target.this : key => target.id
  }
}
output "access_point_ids" {
  description = "Access point IDs keyed by logical name."
  value = { for key, point in aws_efs_access_point.this : key => point.id
  }
}
