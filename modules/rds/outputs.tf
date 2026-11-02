output "db_instance_id" {
  description = "RDS DB instance ID."
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS DB instance ARN."
  value       = aws_db_instance.this.arn
}

output "endpoint" {
  description = "Database connection endpoint."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Database hostname."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Database listener port."
  value       = aws_db_instance.this.port
}

output "master_user_secret_arn" {
  description = "ARN of the RDS-managed master-user secret."
  value       = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}

output "db_subnet_group_name" {
  description = "DB subnet group name."
  value       = aws_db_subnet_group.this.name
}

output "name" {
  description = "Resolved DB identifier."
  value       = local.name
}
