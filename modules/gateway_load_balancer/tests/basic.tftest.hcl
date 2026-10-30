mock_provider "aws" {}

run "fortigate_gateway_defaults" {
  command = plan

  variables {
    region_code = "use1"
    vpc_id      = "vpc-0123456789abcdef0"

    subnet_mappings = {
      az_a = {
        availability_zone = "us-east-1a"
        subnet_id         = "subnet-0123456789abcdef0"
      }
      az_b = {
        availability_zone = "us-east-1b"
        subnet_id         = "subnet-0123456789abcdef1"
      }
    }

    targets = {
      fortigate_a = {
        availability_zone = "us-east-1a"
        ip                = "10.0.10.10"
      }
      fortigate_b = {
        availability_zone = "us-east-1b"
        ip                = "10.0.20.10"
      }
    }
  }

  assert {
    condition     = output.name == "gwlb-network-use1-dev-001"
    error_message = "Generated Gateway Load Balancer name is incorrect."
  }

  assert {
    condition     = aws_lb.this.load_balancer_type == "gateway"
    error_message = "The load balancer must be a Gateway Load Balancer."
  }

  assert {
    condition     = aws_lb_target_group.this.protocol == "GENEVE" && aws_lb_target_group.this.port == 6081
    error_message = "FortiGate targets must use GENEVE on port 6081."
  }

  assert {
    condition     = aws_lb.this.enable_cross_zone_load_balancing
    error_message = "Cross-zone load balancing should be enabled by default."
  }
}

run "fortigate_https_health_check" {
  command = plan

  variables {
    region_code = "use1"
    vpc_id      = "vpc-0123456789abcdef0"
    subnet_mappings = {
      az_a = { availability_zone = "us-east-1a", subnet_id = "subnet-0123456789abcdef0" }
    }
    targets = {
      fortigate_a = { availability_zone = "us-east-1a", ip = "10.0.10.10" }
    }
    health_check = {
      protocol = "HTTPS"
      port     = 443
      path     = "/"
    }
  }

  assert {
    condition     = aws_lb_target_group.this.health_check[0].protocol == "HTTPS" && aws_lb_target_group.this.health_check[0].port == "443"
    error_message = "HTTPS health checks must be passed through to the FortiGate target."
  }
}

run "reject_unsafe_production_defaults" {
  command = plan

  variables {
    environment                = "prod"
    enable_deletion_protection = false
    region_code                = "use1"
    vpc_id                     = "vpc-0123456789abcdef0"
    subnet_mappings = {
      az_a = { availability_zone = "us-east-1a", subnet_id = "subnet-0123456789abcdef0" }
      az_b = { availability_zone = "us-east-1b", subnet_id = "subnet-0123456789abcdef1" }
    }
    targets = {
      fortigate_a = { availability_zone = "us-east-1a", ip = "10.0.10.10" }
      fortigate_b = { availability_zone = "us-east-1b", ip = "10.0.20.10" }
    }
  }

  expect_failures = [aws_lb.this]
}
