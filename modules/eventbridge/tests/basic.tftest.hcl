mock_provider "aws" {}
run "custom_bus_rule" {
  command = plan
  variables {
    name  = "platform-events"
    rules = { hourly = { schedule_expression = "rate(1 hour)" } }
  }
  assert {
    condition     = aws_cloudwatch_event_rule.this["hourly"].state == "ENABLED"
    error_message = "Rules must default enabled."
  }
}
