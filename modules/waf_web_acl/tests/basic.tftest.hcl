mock_provider "aws" {}
run "managed_protection_defaults" {
  command = plan
  variables {
    region_code = "use1"
  }
  assert {
    condition     = length(aws_wafv2_web_acl.this.rule) == 1
    error_message = "The common managed rule group must be enabled by default."
  }
  assert {
    condition     = aws_wafv2_web_acl.this.visibility_config[0].cloudwatch_metrics_enabled
    error_message = "Metrics must be enabled."
  }
}
