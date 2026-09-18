output "service_id" {
  description = "ECS service ID."
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "Resolved ECS service name."
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "Task definition ARN including revision."
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Task definition family."
  value       = aws_ecs_task_definition.this.family
}

output "task_definition_revision" {
  description = "Task definition revision."
  value       = aws_ecs_task_definition.this.revision
}
