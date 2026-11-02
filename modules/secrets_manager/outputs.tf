output "secret_id" {
  description = "Secret ID."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_arn" {
  description = "Secret ARN."
  value       = aws_secretsmanager_secret.this.arn
}

output "name" {
  description = "Resolved secret name."
  value       = local.name
}

output "replica_status" {
  description = "Replication status reported by Secrets Manager."
  value       = aws_secretsmanager_secret.this.replica
}
