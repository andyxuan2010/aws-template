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
  source               = "../.."
  region_code          = "use1"
  image_id             = "ami-0123456789abcdef0"
  instance_type        = "m7i.large"
  instance_profile_arn = "arn:aws:iam::111122223333:instance-profile/app"
  subnet_ids           = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  security_group_ids   = ["sg-0123456789abcdef0"]
}
