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
  cidr_block  = "10.20.0.0/16"
  subnets = {
    public-a = {
      cidr_block        = "10.20.0.0/24"
      availability_zone = "us-east-1a"
      public            = true
    }
    private-a = {
      cidr_block        = "10.20.10.0/24"
      availability_zone = "us-east-1a"
    }
  }
}
