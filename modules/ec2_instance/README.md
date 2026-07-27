# EC2 instance module

Creates one hardened EC2 instance. AMI selection, networking, IAM permissions,
and security-group rules remain explicit root-composition responsibilities.

Secure defaults require IMDSv2, encrypt the root EBS volume, enable detailed
monitoring and termination protection, and do not assign a public address.
Production additionally rejects public IP addresses or disabled termination
protection.

```hcl
module "app_instance" {
  source = "../../modules/ec2_instance"

  ami_id                    = "ami-0123456789abcdef0"
  instance_type             = "t3.small"
  subnet_id                 = module.vpc.private_subnet_ids["private-a"]
  security_group_ids        = [module.security_group.security_group_id]
  iam_instance_profile_name = module.iam_role.instance_profile_name
  region_code               = "use1"
}
```

Prefer SSM Session Manager over SSH key pairs. Never place credentials in
`user_data`; Terraform state and instance metadata can expose that content.
