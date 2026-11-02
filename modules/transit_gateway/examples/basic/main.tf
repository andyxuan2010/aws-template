terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "example" {
  source      = "../.."
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
