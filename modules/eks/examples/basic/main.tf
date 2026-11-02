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
  kubernetes_version = "1.37"
  cluster_role_arn   = "arn:aws:iam::111122223333:role/eks-control-plane"
  admin_role_arn     = "arn:aws:iam::111122223333:role/platform-admin"
  kms_key_arn        = "arn:aws:kms:us-east-1:111122223333:key/00000000-0000-0000-0000-000000000000"
  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  node_groups = {
    system = {
      node_role_arn  = "arn:aws:iam::111122223333:role/eks-node"
      instance_types = ["m7i.large"]
      min_size       = 2
      desired_size   = 2
      max_size       = 4
    }
  }
}
