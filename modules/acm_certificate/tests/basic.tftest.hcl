mock_provider "aws" {}
run "certificate_request" {
  command = plan
  variables {
    domain_name         = "api.example.com"
    wait_for_validation = false
  }
  assert {
    condition     = aws_acm_certificate.this.validation_method == "DNS"
    error_message = "DNS validation must be the default."
  }
  assert {
    condition     = aws_acm_certificate.this.options[0].certificate_transparency_logging_preference == "ENABLED"
    error_message = "CT logging must be enabled."
  }
}
run "reject_dns_wait_without_zone" {
  command = plan
  variables {
    domain_name = "api.example.com"
  }
  expect_failures = [aws_acm_certificate.this]
}
