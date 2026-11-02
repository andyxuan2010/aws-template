output "repository_arn" {
  description = "Repository ARN."
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "Resolved repository name."
  value       = aws_ecr_repository.this.name
}

output "repository_url" {
  description = "Registry URL used for image pushes and pulls."
  value       = aws_ecr_repository.this.repository_url
}

output "registry_id" {
  description = "Registry account ID."
  value       = aws_ecr_repository.this.registry_id
}
