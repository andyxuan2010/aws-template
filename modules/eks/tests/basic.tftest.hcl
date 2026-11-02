mock_provider "aws" {}

run "private_encrypted_cluster" {
  command = plan

  variables {
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

  assert {
    condition     = aws_eks_cluster.this.vpc_config[0].endpoint_private_access && !aws_eks_cluster.this.vpc_config[0].endpoint_public_access
    error_message = "The EKS API must be private by default."
  }

  assert {
    condition     = aws_eks_cluster.this.encryption_config[0].provider[0].key_arn == "arn:aws:kms:us-east-1:111122223333:key/00000000-0000-0000-0000-000000000000"
    error_message = "Kubernetes secrets must use the supplied KMS key."
  }

  assert {
    condition     = aws_eks_node_group.this["system"].scaling_config[0].min_size == 2 && aws_eks_node_group.this["system"].scaling_config[0].max_size == 4
    error_message = "The managed node group must retain its configured capacity bounds."
  }
}

run "rejects_open_public_api" {
  command = plan

  variables {
    region_code                  = "use1"
    kubernetes_version           = "1.37"
    cluster_role_arn             = "arn:aws:iam::111122223333:role/eks-control-plane"
    admin_role_arn               = "arn:aws:iam::111122223333:role/platform-admin"
    kms_key_arn                  = "arn:aws:kms:us-east-1:111122223333:key/00000000-0000-0000-0000-000000000000"
    subnet_ids                   = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    endpoint_public_access       = true
    endpoint_public_access_cidrs = ["0.0.0.0/0"]
  }

  expect_failures = [aws_eks_cluster.this]
}
