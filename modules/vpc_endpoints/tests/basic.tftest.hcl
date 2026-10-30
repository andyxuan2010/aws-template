mock_provider "aws" {}

run "interface_and_gateway_endpoints" {
  command = plan

  variables {
    vpc_id      = "vpc-0123456789abcdef0"
    region_code = "use1"
    endpoints = {
      ssm = {
        service_name       = "com.amazonaws.us-east-1.ssm"
        subnet_ids         = ["subnet-0123456789abcdef0"]
        security_group_ids = ["sg-0123456789abcdef0"]
      }
      s3 = {
        service_name    = "com.amazonaws.us-east-1.s3"
        type            = "Gateway"
        route_table_ids = ["rtb-0123456789abcdef0"]
      }
    }
  }

  assert {
    condition     = aws_vpc_endpoint.this["ssm"].private_dns_enabled
    error_message = "Interface endpoint private DNS should be enabled by default."
  }

  assert {
    condition     = aws_vpc_endpoint.this["s3"].route_table_ids == toset(["rtb-0123456789abcdef0"])
    error_message = "Gateway endpoint route table associations were not passed through."
  }

  assert {
    condition     = aws_vpc_endpoint.this["ssm"].tags["Name"] == "vpce-platform-ssm-use1-dev-001"
    error_message = "Endpoint Name tags must follow the repository naming convention."
  }
}

run "reject_interface_without_security_group" {
  command = plan

  variables {
    vpc_id      = "vpc-0123456789abcdef0"
    region_code = "use1"
    endpoints = {
      ssm = {
        service_name = "com.amazonaws.us-east-1.ssm"
        subnet_ids   = ["subnet-0123456789abcdef0"]
      }
    }
  }

  expect_failures = [aws_vpc_endpoint.this]
}
