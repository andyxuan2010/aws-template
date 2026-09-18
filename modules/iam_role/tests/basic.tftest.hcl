mock_provider "aws" {}

run "role_defaults" {
  command = plan

  variables {
    assume_role_policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }]
    })
  }

  assert {
    condition     = aws_iam_role.this.name == "iam-platform-dev-001"
    error_message = "Generated IAM role name is incorrect."
  }

  assert {
    condition     = length(aws_iam_role_policy_attachment.this) == 0
    error_message = "No managed policy should be attached implicitly."
  }
}

run "typed_trust_policy" {
  command = plan

  override_data {
    target = data.aws_iam_policy_document.trust
    values = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
    }
  }

  variables {
    trust_policy_statements = [{
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }]
    }]
  }

  assert {
    condition     = aws_iam_role.this.name == "iam-platform-dev-001"
    error_message = "Typed trust policies must produce a valid role plan."
  }
}
