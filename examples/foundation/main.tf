module "vpc" {
  source = "../../modules/vpc"

  workload         = local.workload
  region_code      = local.region_code
  environment      = local.environment
  cidr_block       = "10.20.0.0/16"
  nat_gateway_mode = "per_az"
  inherited_tags   = local.inherited_tags

  subnets = {
    public-a = {
      cidr_block        = "10.20.0.0/24"
      availability_zone = "${var.aws_region}a"
      public            = true
    }
    public-b = {
      cidr_block        = "10.20.1.0/24"
      availability_zone = "${var.aws_region}b"
      public            = true
    }
    private-a = {
      cidr_block        = "10.20.10.0/24"
      availability_zone = "${var.aws_region}a"
    }
    private-b = {
      cidr_block        = "10.20.11.0/24"
      availability_zone = "${var.aws_region}b"
    }
  }
}

module "security_group" {
  source = "../../modules/security_group"

  workload       = local.workload
  region_code    = local.region_code
  environment    = local.environment
  vpc_id         = module.vpc.vpc_id
  inherited_tags = local.inherited_tags

  ingress_rules = {
    internal_https = {
      description = "HTTPS from inside the VPC"
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "10.20.0.0/16"
    }
  }

  egress_rules = {
    internal_https = {
      description = "HTTPS to resources inside the VPC"
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = "10.20.0.0/16"
    }
  }
}

module "kms" {
  source = "../../modules/kms_key"

  workload       = local.workload
  region_code    = local.region_code
  environment    = local.environment
  inherited_tags = local.inherited_tags
}

module "s3_bucket" {
  source = "../../modules/s3_bucket"

  name           = var.bucket_name
  workload       = local.workload
  region_code    = local.region_code
  environment    = local.environment
  kms_key_arn    = module.kms.key_arn
  inherited_tags = local.inherited_tags

  lifecycle_rules = {
    housekeeping = {
      noncurrent_version_expiration   = 90
      abort_incomplete_multipart_days = 7
    }
  }
}

module "iam_role" {
  source = "../../modules/iam_role"

  workload       = local.workload
  environment    = local.environment
  inherited_tags = local.inherited_tags

  trust_policy_statements = [{
    sid     = "AllowEC2AssumeRole"
    actions = ["sts:AssumeRole"]
    principals = [{
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }]
  }]

  inline_policies = {
    read_foundation_bucket = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          module.s3_bucket.bucket_arn,
          "${module.s3_bucket.bucket_arn}/*"
        ]
      }]
    })
  }
}
