output "table_id" {
  description = "DynamoDB table ID."
  value       = aws_dynamodb_table.this.id
}

output "table_name" {
  description = "Resolved table name."
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "DynamoDB table ARN."
  value       = aws_dynamodb_table.this.arn
}

output "stream_arn" {
  description = "Latest DynamoDB stream ARN, or null when streams are disabled."
  value       = aws_dynamodb_table.this.stream_arn
}

output "stream_label" {
  description = "Latest DynamoDB stream label."
  value       = aws_dynamodb_table.this.stream_label
}
