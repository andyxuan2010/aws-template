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
  role_arn    = "arn:aws:iam::123456789012:role/lambda-role"
  filename    = "function.zip"
  runtime     = "python3.13"
  handler     = "handler.main"
}
