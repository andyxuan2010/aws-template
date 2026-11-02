output "function_name" {
  description = "Resolved Lambda function name."
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "Unqualified function ARN."
  value       = aws_lambda_function.this.arn
}

output "qualified_arn" {
  description = "Version-qualified function ARN when publish is enabled."
  value       = aws_lambda_function.this.qualified_arn
}

output "version" {
  description = "Published function version."
  value       = aws_lambda_function.this.version
}

output "invoke_arn" {
  description = "ARN used to invoke the function from API Gateway."
  value       = aws_lambda_function.this.invoke_arn
}

output "last_modified" {
  description = "Timestamp of the last function modification."
  value       = aws_lambda_function.this.last_modified
}
