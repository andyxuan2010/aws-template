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
  cluster_arn        = "arn:aws:ecs:us-east-1:123456789012:cluster/platform"
  execution_role_arn = "arn:aws:iam::123456789012:role/ecs-execution"
  subnet_ids         = ["subnet-0123456789abcdef0"]
  security_group_ids = ["sg-0123456789abcdef0"]
  container_definitions_json = jsonencode([{
    name      = "api"
    image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/api:v1"
    essential = true
  }])
}
