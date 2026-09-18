output "api_id" {
  description = "API ID."
  value       = aws_apigatewayv2_api.this.id
}
output "api_arn" {
  description = "API ARN."
  value       = aws_apigatewayv2_api.this.arn
}
output "api_endpoint" {
  description = "Default API endpoint."
  value       = aws_apigatewayv2_api.this.api_endpoint
}
output "execution_arn" {
  description = "API execution ARN."
  value       = aws_apigatewayv2_api.this.execution_arn
}
output "stage_arn" {
  description = "Stage ARN."
  value       = aws_apigatewayv2_stage.this.arn
}
output "invoke_url" {
  description = "Stage invoke URL."
  value       = aws_apigatewayv2_stage.this.invoke_url
}
output "tags" {
  description = "Effective tags."
  value       = local.tags
}
