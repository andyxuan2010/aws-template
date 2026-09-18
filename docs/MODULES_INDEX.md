# Modules Index

| Module | Primary resources | Important secure defaults |
| --- | --- | --- |
| `vpc` | VPC, subnet, IGW, EIP, NAT gateway, route table | DNS support enabled; explicit subnet routing |
| `security_group` | Security group, standalone ingress/egress rules | No implicit ingress; explicit egress rules |
| `s3_bucket` | S3 bucket and security controls | Public access blocked, TLS required, encryption and versioning enabled |
| `iam_role` | IAM role, attachments, inline policies, instance profile | Explicit trust policy; optional permissions boundary |
| `kms_key` | KMS key, alias, grants | Rotation enabled; deletion window guardrail |
| `ec2_instance` | EC2 instance, encrypted root EBS volume | IMDSv2 required; no public IP; termination protection |
| `fortigate` | FortiGate-VM EC2 instances and additional ENIs | Explicit AMI and licensing mode; no public IP; IMDSv2; encrypted root volume |
| `gateway_load_balancer` | Gateway Load Balancer, GENEVE target group, listener, and FortiGate IP targets | GENEVE 6081; cross-zone balancing; deletion protection; explicit per-AZ target coverage |
| `route_manager` | VPC routes targeting FortiGate ENIs or GWLB endpoints | Explicit route ownership; validated next-hop types; declarative primary/secondary target switch |
| `application_load_balancer` | ALB, target groups, listeners | Internal by default; HTTPS required for public listeners |
| `rds` | DB instance, DB subnet group | Managed password; private, encrypted, Multi-AZ, recoverable |
| `lambda_function` | Lambda function | Immutable versions; active tracing; explicit package source |
| `secrets_manager` | Secret metadata, policy, rotation, replicas | No secret values in state; 30-day recovery |
| `ecr_repository` | ECR repository, lifecycle and access policies | Immutable tags; scan on push; encryption |
| `ecs_service` | Fargate task definition and ECS service | Private tasks; circuit breaker; production redundancy |
| `dynamodb_table` | DynamoDB table and indexes | On-demand billing; encryption; PITR; deletion protection |
| `sqs_queue` | Standard or FIFO SQS queue | Encryption; long polling; production DLQ |
| `sns_topic` | Standard or FIFO SNS topic and subscriptions | Encryption; signature v2; no implicit HTTP |
| `route53` | Public/private hosted zone and records | No force deletion; explicit VPC and routing-policy inputs |
| `acm_certificate` | ACM certificate and DNS validation | DNS validation, CT logging, safe replacement |
| `cloudwatch_monitoring` | Log groups, metric alarms, dashboard | One-year log retention; explicit alarm actions |
| `waf_web_acl` | WAFv2 web ACL and associations | AWS managed common rules, metrics, request sampling |
| `api_gateway` | API Gateway v2 API, integrations, routes, stage | Production access logs; explicit authorization per route |
| `eventbridge` | Event bus, rules, targets, archive | Explicit target retry and dead-letter controls |
| `step_functions` | State machine | X-Ray enabled; execution payload logging disabled |
| `aws_backup` | Backup vault, plan, selections, Vault Lock | Customer-managed encryption; 35-day retention; no production force deletion |

Modules are intentionally composable and do not configure the AWS provider,
backend, Organizations hierarchy, or account credentials.

## Module layers

The modules are workload and platform primitives. Higher-level foundation and
landing-zone compositions should compose these primitives rather than duplicating
their security and lifecycle controls. Secrets Manager intentionally manages
metadata only; values must be populated without passing plaintext through
Terraform.

See [Module Usage and Dependencies](MODULE_USAGE_AND_DEPENDENCIES.md) for the
recommended composition order and cross-module contracts.
