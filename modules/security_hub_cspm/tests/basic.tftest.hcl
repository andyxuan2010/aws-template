mock_provider "aws" {}

run "enables_cspm_without_implicit_standards" {
  command = plan

  variables {
    standards_arns           = ["arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"]
    aggregation_linking_mode = "ALL_REGIONS"
  }

  assert {
    condition     = aws_securityhub_account.this.auto_enable_controls && !aws_securityhub_account.this.enable_default_standards
    error_message = "CSPM controls should auto-enable while the module explicitly selects standards."
  }

  assert {
    condition     = length(aws_securityhub_standards_subscription.this) == 1
    error_message = "Each explicitly supplied Security Hub standard must be subscribed."
  }

  assert {
    condition     = aws_securityhub_finding_aggregator.this[0].linking_mode == "ALL_REGIONS"
    error_message = "The finding aggregator must use the configured linking mode."
  }
}

run "rejects_empty_specified_region_set" {
  command = plan

  variables {
    aggregation_linking_mode = "SPECIFIED_REGIONS"
    specified_regions        = []
  }

  expect_failures = [aws_securityhub_finding_aggregator.this[0]]
}
