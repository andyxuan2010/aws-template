mock_provider "aws" {}

run "secure_vpc_defaults" {
  command = plan

  variables {
    region_code = "use1"
    cidr_block  = "10.20.0.0/16"
    subnets = {
      public-a = {
        cidr_block        = "10.20.0.0/24"
        availability_zone = "us-east-1a"
        public            = true
      }
      private-a = {
        cidr_block        = "10.20.10.0/24"
        availability_zone = "us-east-1a"
      }
    }
  }

  assert {
    condition     = aws_vpc.this.enable_dns_support
    error_message = "DNS support should be enabled by default."
  }

  assert {
    condition     = output.name == "vpc-platform-use1-dev-001"
    error_message = "The generated name does not follow the repository convention."
  }

  assert {
    condition     = length(aws_nat_gateway.this) == 0
    error_message = "NAT gateways must be opt-in."
  }
}
