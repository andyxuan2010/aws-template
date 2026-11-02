mock_provider "aws" {}

run "default_rules" {
  command = plan

  variables {
    region_code = "use1"
    vpc_id      = "vpc-0123456789abcdef0"
  }

  assert {
    condition     = output.name == "secgrp-platform-use1-dev-001"
    error_message = "Generated security group name is incorrect."
  }

  assert {
    condition     = length(aws_vpc_security_group_ingress_rule.this) == 0
    error_message = "Ingress should be denied by default."
  }

  assert {
    condition     = length(aws_vpc_security_group_egress_rule.this) == 0
    error_message = "Egress should be denied by default."
  }
}

run "reject_implicit_public_ingress" {
  command = plan

  variables {
    region_code = "use1"
    vpc_id      = "vpc-0123456789abcdef0"
    ingress_rules = {
      https = {
        ip_protocol = "tcp"
        from_port   = 443
        to_port     = 443
        cidr_ipv4   = "0.0.0.0/0"
      }
    }
  }

  expect_failures = [aws_security_group.this]
}
