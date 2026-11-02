mock_provider "aws" {}

variables {
  region_code        = "use1"
  vpc_id             = "vpc-0123456789abcdef0"
  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-1123456789abcdef0"]
  security_group_ids = ["sg-0123456789abcdef0"]
  target_groups = {
    app = { port = 8080 }
  }
  listeners = {
    https = {
      port             = 443
      protocol         = "HTTPS"
      target_group_key = "app"
      certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    }
  }
}

run "secure_internal_defaults" {
  command = plan

  assert {
    condition     = aws_lb.this.internal
    error_message = "The ALB must be internal by default."
  }

  assert {
    condition     = aws_lb.this.drop_invalid_header_fields
    error_message = "Invalid headers must be dropped."
  }

  assert {
    condition = (
      aws_lb_listener.this["https"].protocol == "HTTPS" &&
      aws_lb_listener.this["https"].port == 443 &&
      aws_lb_listener.this["https"].certificate_arn == var.listeners["https"].certificate_arn &&
      aws_lb_listener.this["https"].ssl_policy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    )
    error_message = "Listeners must use HTTPS with the supplied certificate and secure TLS policy."
  }
}

run "secure_internet_facing_https" {
  command = plan

  variables {
    internal = false
  }
}

run "reject_internal_http" {
  command = plan

  variables {
    listeners = {
      http = {
        port             = 80
        protocol         = "HTTP"
        target_group_key = "app"
        certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
      }
    }
  }

  expect_failures = [var.listeners]
}

run "reject_internet_facing_http" {
  command = plan

  variables {
    internal = false
    listeners = {
      http = {
        port             = 80
        protocol         = "HTTP"
        target_group_key = "app"
        certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
      }
    }
  }

  expect_failures = [var.listeners]
}

run "reject_https_without_certificate" {
  command = plan

  variables {
    listeners = {
      https = {
        port             = 443
        protocol         = "HTTPS"
        target_group_key = "app"
      }
    }
  }

  expect_failures = [var.listeners]
}

run "reject_https_with_blank_certificate" {
  command = plan

  variables {
    listeners = {
      https = {
        port             = 443
        protocol         = "HTTPS"
        target_group_key = "app"
        certificate_arn  = "   "
      }
    }
  }

  expect_failures = [var.listeners]
}
