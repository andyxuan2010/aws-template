mock_provider "aws" {}

run "segmented_transit_gateway" {
  command = plan

  variables {
    region_code = "use1"
    route_tables = {
      workloads = {
        routes = {
          shared_services = {
            destination_cidr_block = "10.30.0.0/16"
            attachment_key         = "shared"
          }
        }
      }
      shared = {}
    }
    attachments = {
      workload = {
        vpc_id                      = "vpc-0123456789abcdef0"
        subnet_ids                  = ["subnet-0123456789abcdef0"]
        route_table_key             = "workloads"
        propagated_route_table_keys = ["shared"]
      }
      shared = {
        vpc_id          = "vpc-abcdef01234567890"
        subnet_ids      = ["subnet-abcdef01234567890"]
        route_table_key = "shared"
      }
    }
  }

  assert {
    condition     = aws_ec2_transit_gateway.this.default_route_table_association == "disable"
    error_message = "Default route table association must be disabled for explicit routing."
  }

  assert {
    condition     = aws_ec2_transit_gateway_vpc_attachment.this["workload"].dns_support == "enable"
    error_message = "DNS support should be enabled on VPC attachments by default."
  }

  assert {
    condition     = length(aws_ec2_transit_gateway_route_table_association.this) == 2
    error_message = "Every VPC attachment should have one explicit route table association."
  }

  assert {
    condition     = aws_ec2_transit_gateway_route.this["workloads/shared_services"].destination_cidr_block == "10.30.0.0/16"
    error_message = "Static route configuration was not passed through."
  }

  assert {
    condition     = output.transit_gateway_name == "tgw-platform-use1-dev-001"
    error_message = "The generated transit gateway name does not follow the repository convention."
  }
}

run "reject_public_asn" {
  command = plan

  variables {
    region_code     = "use1"
    amazon_side_asn = 12345
    route_tables = {
      workloads = {}
    }
    attachments = {
      workload = {
        vpc_id          = "vpc-0123456789abcdef0"
        subnet_ids      = ["subnet-0123456789abcdef0"]
        route_table_key = "workloads"
      }
    }
  }

  expect_failures = [var.amazon_side_asn]
}
