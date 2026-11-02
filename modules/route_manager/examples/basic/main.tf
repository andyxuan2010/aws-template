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
