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
  source                 = "../.."
  engine                 = "postgres"
  engine_version         = "16.4"
  instance_class         = "db.t4g.small"
  master_username        = "platform_admin"
  region_code            = "use1"
  subnet_ids             = ["subnet-0123456789abcdef0", "subnet-1123456789abcdef0"]
  vpc_security_group_ids = ["sg-0123456789abcdef0"]
}
