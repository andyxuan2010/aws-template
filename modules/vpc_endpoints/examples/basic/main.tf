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
