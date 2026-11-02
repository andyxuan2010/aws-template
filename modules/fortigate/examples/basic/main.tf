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
  ami_id             = "ami-0123456789abcdef0"
  region_code        = "use1"
  security_group_ids = ["sg-0123456789abcdef0"]
  interfaces = {
    external = {
      role         = "external"
      primary      = true
      device_index = 0
      subnet_id    = "subnet-0123456789abcdef0"
    }
    internal = {
      role         = "internal"
      device_index = 1
      subnet_id    = "subnet-0123456789abcdef1"
    }
  }
}
