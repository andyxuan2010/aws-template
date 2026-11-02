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
  source                   = "../.."
  standards_arns           = ["arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"]
  aggregation_linking_mode = "ALL_REGIONS"
}
