mock_provider "aws" {}

run "fortigate_eni_route" {
  command = plan

  variables {
    region_code = "use1"
    routes = {
      inspection = {
        route_table_id         = "rtb-0123456789abcdef0"
        destination_cidr_block = "0.0.0.0/0"
        target = {
          type = "network_interface_id"
          id   = "eni-0123456789abcdef0"
        }
      }
    }
  }

  assert {
    condition     = aws_route.this["inspection"].network_interface_id == "eni-0123456789abcdef0"
    error_message = "The route must target the FortiGate network interface."
  }

  assert {
    condition     = output.failover_enabled["inspection"] == false
    error_message = "A route without a secondary target must not report failover enabled."
  }
}

run "declarative_route_failover" {
  command = plan

  variables {
    region_code = "use1"
    routes = {
      inspection = {
        route_table_id         = "rtb-0123456789abcdef0"
        destination_cidr_block = "0.0.0.0/0"
        target = {
          type = "network_interface_id"
          id   = "eni-primary0123456789"
        }
        failover = {
          active_target = "secondary"
          secondary_target = {
            type = "network_interface_id"
            id   = "eni-secondary0123456789"
          }
        }
      }
    }
  }

  assert {
    condition     = aws_route.this["inspection"].network_interface_id == "eni-secondary0123456789"
    error_message = "The secondary FortiGate ENI must become the effective route target when selected."
  }

  assert {
    condition     = output.active_targets["inspection"].id == "eni-secondary0123456789"
    error_message = "The active target output must describe the selected failover target."
  }
}

run "gwlb_endpoint_route" {
  command = plan

  variables {
    region_code = "use1"
    routes = {
      inspection = {
        route_table_id         = "rtb-0123456789abcdef0"
        destination_cidr_block = "10.20.0.0/16"
        target = {
          type = "vpc_endpoint_id"
          id   = "vpce-0123456789abcdef0"
        }
      }
    }
  }

  assert {
    condition     = aws_route.this["inspection"].vpc_endpoint_id == "vpce-0123456789abcdef0"
    error_message = "GWLB inspection routes must support VPC endpoint targets."
  }
}
