mock_provider "aws" {}
run "secure_log_retention" {
  command = plan
  variables {
    region_code = "use1"
    log_groups  = { app = {} }
  }
  assert {
    condition     = aws_cloudwatch_log_group.this["app"].retention_in_days == 365
    error_message = "Log retention must default to one year."
  }
}
