mock_provider "aws" {}

run "secure_single_defaults" {
  command = plan

  variables {
    ami_id             = "ami-0123456789abcdef0"
    region_code        = "use1"
    security_group_ids = ["sg-0123456789abcdef0"]
    interfaces = {
      external = {
        role         = "external"
        primary      = true
        device_index = 0
        subnet_id    = "subnet-0123456789abcdef0"
      }
      internal = {
        role         = "internal"
        device_index = 1
        subnet_id    = "subnet-0123456789abcdef1"
      }
    }
  }

  assert {
    condition     = output.architecture == "single"
    error_message = "The default architecture must be single."
  }

  assert {
    condition     = !aws_instance.this["a"].associate_public_ip_address
    error_message = "Public IP assignment must be disabled by default."
  }

  assert {
    condition     = aws_instance.this["a"].metadata_options[0].http_tokens == "required"
    error_message = "IMDSv2 must be required."
  }

  assert {
    condition     = aws_instance.this["a"].root_block_device[0].encrypted
    error_message = "The root volume must be encrypted."
  }
}

run "active_passive_bootstrap" {
  command = plan

  variables {
    ami_id             = "ami-0123456789abcdef0"
    architecture       = "active-passive"
    region_code        = "use1"
    security_group_ids = ["sg-0123456789abcdef0"]
    interfaces = {
      external = {
        role         = "external"
        primary      = true
        device_index = 0
        subnet_ids   = { a = "subnet-0123456789abcdef0", b = "subnet-0123456789abcdef2" }
      }
      ha = {
        role         = "ha"
        device_index = 1
        subnet_ids   = { a = "subnet-0123456789abcdef1", b = "subnet-0123456789abcdef3" }
        private_ips  = { a = "10.0.1.10", b = "10.0.2.10" }
      }
    }
    bootstrap = {
      config = "config system global\n    set timezone 04\nend"
    }
  }

  assert {
    condition     = length(aws_instance.this) == 2
    error_message = "Active-passive architecture must create two instances."
  }

  assert {
    condition     = output.bootstrap_applied["a"] && output.bootstrap_applied["b"]
    error_message = "Bootstrap user data must be generated for both HA nodes."
  }
}

run "reject_public_production" {
  command = plan

  variables {
    ami_id                      = "ami-0123456789abcdef0"
    region_code                 = "use1"
    associate_public_ip_address = true
    allow_public_ip             = true
    environment                 = "prod"
    security_group_ids          = ["sg-0123456789abcdef0"]
    interfaces = {
      external = {
        role         = "external"
        primary      = true
        device_index = 0
        subnet_id    = "subnet-0123456789abcdef0"
      }
    }
  }

  expect_failures = [aws_instance.this["a"]]
}
