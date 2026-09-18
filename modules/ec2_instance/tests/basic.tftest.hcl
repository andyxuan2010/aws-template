mock_provider "aws" {}

run "secure_defaults" {
  command = plan

  variables {
    ami_id             = "ami-0123456789abcdef0"
    subnet_id          = "subnet-0123456789abcdef0"
    security_group_ids = ["sg-0123456789abcdef0"]
    region_code        = "use1"
  }

  assert {
    condition     = aws_instance.this.metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 must be required."
  }

  assert {
    condition     = aws_instance.this.root_block_device[0].encrypted
    error_message = "The root volume must be encrypted."
  }

  assert {
    condition     = !aws_instance.this.associate_public_ip_address
    error_message = "Public IP assignment must be disabled by default."
  }
}

run "reject_public_production_instance" {
  command = plan

  variables {
    ami_id                      = "ami-0123456789abcdef0"
    subnet_id                   = "subnet-0123456789abcdef0"
    security_group_ids          = ["sg-0123456789abcdef0"]
    region_code                 = "use1"
    environment                 = "prod"
    associate_public_ip_address = true
  }

  expect_failures = [aws_instance.this]
}
