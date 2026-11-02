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
  subnet_ids         = { az_a = "subnet-0123456789abcdef0", az_b = "subnet-0123456789abcdef1" }
  security_group_ids = ["sg-0123456789abcdef0"]
  access_points = {
    application = {
      path         = "/application"
      owner_uid    = 10001
      owner_gid    = 10001
      creation_uid = 10001
      creation_gid = 10001
    }
  }
}
