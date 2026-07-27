# Modules Index

| Module | Primary resources | Important secure defaults |
| --- | --- | --- |
| `vpc` | VPC, subnet, IGW, EIP, NAT gateway, route table | DNS support enabled; explicit subnet routing |
| `security_group` | Security group, standalone ingress/egress rules | No implicit ingress; explicit egress rules |
| `s3_bucket` | S3 bucket and security controls | Public access blocked, TLS required, encryption and versioning enabled |
| `iam_role` | IAM role, attachments, inline policies, instance profile | Explicit trust policy; optional permissions boundary |
| `kms_key` | KMS key, alias, grants | Rotation enabled; deletion window guardrail |
| `ec2_instance` | EC2 instance, encrypted root EBS volume | IMDSv2 required; no public IP; termination protection |
| `application_load_balancer` | ALB, target groups, listeners | Internal by default; HTTPS required for public listeners |
| `rds` | DB instance, DB subnet group | Managed password; private, encrypted, Multi-AZ, recoverable |
| `lambda_function` | Lambda function | Immutable versions; active tracing; explicit package source |
| `secrets_manager` | Secret metadata, policy, rotation, replicas | No secret values in state; 30-day recovery |
| `ecr_repository` | ECR repository, lifecycle and access policies | Immutable tags; scan on push; encryption |
| `ecs_service` | Fargate task definition and ECS service | Private tasks; circuit breaker; production redundancy |
| `dynamodb_table` | DynamoDB table and indexes | On-demand billing; encryption; PITR; deletion protection |
| `sqs_queue` | Standard or FIFO SQS queue | Encryption; long polling; production DLQ |
| `sns_topic` | Standard or FIFO SNS topic and subscriptions | Encryption; signature v2; no implicit HTTP |

Modules are intentionally composable and do not configure the AWS provider,
backend, Organizations hierarchy, or account credentials.

## Module layers

The first fifteen modules are workload and platform primitives. Higher-level
landing-zone modules should compose these primitives rather than duplicating
their security and lifecycle controls. Secrets Manager intentionally manages
metadata only; values must be populated without passing plaintext through
Terraform.
