mock_provider "aws" {}

run "secure_internal_defaults" {
  command = plan

  variables {
    region_code        = "use1"
    vpc_id             = "vpc-0123456789abcdef0"
    subnet_ids         = ["subnet-0123456789abcdef0", "subnet-1123456789abcdef0"]
    security_group_ids = ["sg-0123456789abcdef0"]
    target_groups = {
      app = { port = 8080 }
    }
    listeners = {
      http = {
        port             = 80
        protocol         = "HTTP"
        target_group_key = "app"
      }
    }
  }

  assert {
    condition     = aws_lb.this.internal
    error_message = "The ALB must be internal by default."
  }

  assert {
    condition     = aws_lb.this.drop_invalid_header_fields
    error_message = "Invalid headers must be dropped."
  }
}

run "reject_internet_facing_http" {
  command = plan

  variables {
    region_code        = "use1"
    internal           = false
    vpc_id             = "vpc-0123456789abcdef0"
    subnet_ids         = ["subnet-0123456789abcdef0", "subnet-1123456789abcdef0"]
    security_group_ids = ["sg-0123456789abcdef0"]
    target_groups = {
      app = { port = 8080 }
    }
    listeners = {
      http = {
        port             = 80
        protocol         = "HTTP"
        target_group_key = "app"
      }
    }
  }

  expect_failures = [aws_lb_listener.this["http"]]
}
