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
