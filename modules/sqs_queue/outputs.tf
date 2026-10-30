output "queue_id" {
  description = "Queue URL."
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "Queue ARN."
  value       = aws_sqs_queue.this.arn
}

output "queue_name" {
  description = "Resolved queue name."
  value       = aws_sqs_queue.this.name
}

output "queue_url" {
  description = "Queue URL."
  value       = aws_sqs_queue.this.url
}
