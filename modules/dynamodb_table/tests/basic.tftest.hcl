mock_provider "aws" {}

run "secure_on_demand_defaults" {
  command = plan

  variables {
    region_code = "use1"
    hash_key    = "id"
    attributes = {
      id = { type = "S" }
    }
  }

  assert {
    condition     = aws_dynamodb_table.this.billing_mode == "PAY_PER_REQUEST"
    error_message = "On-demand billing must be the default."
  }

  assert {
    condition     = aws_dynamodb_table.this.point_in_time_recovery[0].enabled
    error_message = "Point-in-time recovery must be enabled."
  }
}

run "reject_non_key_attribute_declaration" {
  command = plan

  variables {
    region_code = "use1"
    hash_key    = "id"
    attributes = {
      id          = { type = "S" }
      description = { type = "S" }
    }
  }

  expect_failures = [aws_dynamodb_table.this]
}
