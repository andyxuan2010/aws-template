output "vault_id" {
  description = "Backup vault ID."
  value       = aws_backup_vault.this.id
}
output "vault_arn" {
  description = "Backup vault ARN."
  value       = aws_backup_vault.this.arn
}
output "plan_id" {
  description = "Backup plan ID."
  value       = aws_backup_plan.this.id
}
output "plan_arn" {
  description = "Backup plan ARN."
  value       = aws_backup_plan.this.arn
}
output "selection_ids" {
  description = "Selection IDs keyed by input key."
  value       = { for k, v in aws_backup_selection.this : k => v.id }
}
output "tags" {
  description = "Effective tags."
  value       = local.tags
}
