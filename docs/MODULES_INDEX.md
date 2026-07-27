# Modules Index

| Module | Primary resources | Important secure defaults |
| --- | --- | --- |
| `vpc` | VPC, subnet, IGW, EIP, NAT gateway, route table | DNS support enabled; explicit subnet routing |
| `security_group` | Security group, standalone ingress/egress rules | No implicit ingress; explicit egress rules |
| `s3_bucket` | S3 bucket and security controls | Public access blocked, TLS required, encryption and versioning enabled |
| `iam_role` | IAM role, attachments, inline policies, instance profile | Explicit trust policy; optional permissions boundary |
| `kms_key` | KMS key, alias, grants | Rotation enabled; deletion window guardrail |

Modules are intentionally composable and do not configure the AWS provider,
backend, Organizations hierarchy, or account credentials.
