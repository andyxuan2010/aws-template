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
  source             = "../.."
  region_code        = "use1"
  vpc_id             = "vpc-0123456789abcdef0"
  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-1123456789abcdef0"]
  security_group_ids = ["sg-0123456789abcdef0"]
  target_groups = {
    app = { port = 8080 }
  }
  listeners = {
    https = {
      port             = 443
      protocol         = "HTTPS"
      target_group_key = "app"
      certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
    }
  }
}
