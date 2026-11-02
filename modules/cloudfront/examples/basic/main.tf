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
  source = "../.."
  name   = "web-prod"
  origins = {
    app = { domain_name = "app.example.com" }
    assets = {
      domain_name = "assets.s3.us-east-1.amazonaws.com"
      s3          = true
    }
  }
  default_origin_id = "app"
  cache_policy_id   = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}
