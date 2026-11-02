output "state_machine_id" {
  description = "State machine ID."
  value       = aws_sfn_state_machine.this.id
}
output "state_machine_arn" {
  description = "State machine ARN."
  value       = aws_sfn_state_machine.this.arn
}
output "creation_date" {
  description = "State machine creation date."
  value       = aws_sfn_state_machine.this.creation_date
}
output "tags" {
  description = "Effective tags."
  value       = local.tags
}
