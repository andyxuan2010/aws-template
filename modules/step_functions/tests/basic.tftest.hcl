mock_provider "aws" {}
run "secure_standard_workflow" {
  command = plan
  variables {
    region_code = "use1"
    role_arn    = "arn:aws:iam::123456789012:role/workflow"
    definition  = jsonencode({ StartAt = "Done", States = { Done = { Type = "Succeed" } } })
  }
  assert {
    condition     = aws_sfn_state_machine.this.tracing_configuration[0].enabled
    error_message = "Tracing must default enabled."
  }
}
