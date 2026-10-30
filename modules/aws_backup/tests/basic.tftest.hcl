mock_provider "aws" {}
run "encrypted_recoverable_defaults" {
  command = plan
  variables {
    region_code = "use1"
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/11111111-1111-1111-1111-111111111111"
  }
  assert {
    condition     = aws_backup_vault.this.force_destroy == false
    error_message = "Vault force_destroy must default false."
  }
  assert {
    condition     = one(one(aws_backup_plan.this.rule).lifecycle).delete_after == 35
    error_message = "Default backups must retain for 35 days."
  }
}
run "reject_prod_force_destroy" {
  command = plan
  variables {
    region_code   = "use1"
    environment   = "prod"
    force_destroy = true
    kms_key_arn   = "arn:aws:kms:us-east-1:123456789012:key/11111111-1111-1111-1111-111111111111"
  }
  expect_failures = [aws_backup_vault.this]
}
