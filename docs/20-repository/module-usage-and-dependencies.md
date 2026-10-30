# Module Usage and Dependencies

## Purpose

This guide describes safe composition order and ownership boundaries. Modules
do not discover dependencies implicitly; callers pass IDs and ARNs from module
outputs so plans remain deterministic and cross-account access stays explicit.

The calling root owns provider configuration, credentials, backend state, and
AWS account selection. See the [Repository Architecture](../10-architecture/repository-architecture.md)
and [Foundation Composition Guide](foundation-composition-guide.md) for the
broader ownership model.

## Recommended Composition Order

1. Create foundational encryption and networking with `kms_key`, `vpc`, and
   `security_group`.
2. Create identity and observability with `iam_role`, `sns_topic`, and
   `cloudwatch_monitoring`.
3. Create data and messaging services such as `s3_bucket`, `efs`, `rds`,
   `elasticache`, `dynamodb_table`, `secrets_manager`, `sqs_queue`, and
   `eventbridge`.
4. Create compute and delivery services such as `ec2_instance`, `autoscaling`,
   `eks`, `fortigate`, `gateway_load_balancer`, `route_manager`,
   `lambda_function`, `ecs_service`, `application_load_balancer`, `api_gateway`,
   and `step_functions`.
5. Add edge, DNS, certificate, and protection capabilities with `cloudfront`,
   `route53`, `acm_certificate`, and `waf_web_acl`.
6. Enable account/Region security posture with `security_hub_cspm` after
   AWS Config coverage is planned; use separate Organizations-aware governance
   for delegated administration and central configuration.
7. Add recovery policies with `aws_backup` after protected resource ARNs and
   the AWS Backup service role exist.

## Important Cross-Module Contracts

| Consumer | Typical dependency outputs |
| --- | --- |
| `acm_certificate` | `route53.zone_id` |
| `application_load_balancer` | VPC subnet IDs, security-group IDs, certificate ARN |
| `api_gateway` | Lambda/ECS integration URI, CloudWatch log-group ARN |
| `autoscaling` | Private subnet IDs, security-group IDs, instance-profile ARN, optional target-group ARNs |
| `aws_backup` | KMS key ARN, protected resource ARNs, backup role ARN |
| `cloudfront` | S3 regional domain name, distribution-scoped bucket policy, optional WAF ARN and us-east-1 certificate ARN |
| `efs` | Private subnet IDs and client security-group IDs; NFS access is caller-controlled |
| `ecs_service` | Cluster ARN, subnet/security-group IDs, target-group ARN, IAM role ARNs |
| `eks` | Private subnet IDs, cluster/node IAM role ARNs, administrator role ARN, optional KMS key ARN |
| `elasticache` | Private subnet IDs, cache security-group IDs, ACL user-group IDs |
| `eventbridge` | Target ARN, invocation role ARN, SQS dead-letter ARN |
| `gateway_load_balancer` | VPC ID, per-AZ subnet mappings, and FortiGate traffic-interface private IPs from `fortigate.network_interface_private_ips` |
| `fortigate` | Approved FortiGate AMI, subnet IDs, security-group IDs, and optional IAM instance profile |
| `route_manager` | Route table IDs and FortiGate ENI IDs or GWLB VPC endpoint IDs; failover targets must have one owner |
| `rds` | Private subnet IDs, security-group IDs, KMS key ARN |
| `security_hub_cspm` | Explicit regional standards ARNs; optional aggregator only in the designated home Region |
| `step_functions` | Execution role ARN and CloudWatch log destination ARN |
| `waf_web_acl` | Regional ALB or API Gateway stage ARN |

## FortiGate inspection composition

Use the FortiGate modules as a deliberate traffic-insertion chain:

1. Deploy `fortigate` with an approved AMI, explicit licensing metadata,
   management/traffic/heartbeat interfaces, and bootstrap configuration.
2. Pass the FortiGate traffic-interface private IPs from
   `fortigate.network_interface_private_ips` to `gateway_load_balancer.targets`.
   Do not register management or heartbeat interfaces as GENEVE targets.
3. Create GWLB endpoint services and consumer VPC endpoints in the calling
   composition. Those endpoint resources are intentionally outside the
   `gateway_load_balancer` module.
4. Use `route_manager` to point consumer or inspection route tables at the
   appropriate GWLB endpoint IDs or FortiGate ENI IDs. Keep one Terraform
   owner for each route-table/destination pair.

`route_manager.failover.active_target` supports a controlled, declarative
primary/secondary switch. It is not a health monitor and does not perform
runtime HA promotion. Automatic failover must be owned by FortiGate native HA,
FortiGate/AWS SDN integration, or a separately operated automation service;
that automation must not concurrently manage the same route objects.

The route and GWLB modules do not verify live reachability, GENEVE behavior,
FortiOS licensing, or Marketplace subscription state. Validate those concerns
in a dedicated AWS sandbox integration test before production rollout.

## Provider Ownership

Root modules configure AWS providers, aliases, credentials, default tags, and
backends. Child modules declare only provider source and compatibility ranges.
For global CloudFront WAF or CloudFront ACM certificates, the caller supplies an
`us-east-1` AWS provider configuration.

## State and Lifecycle Safety

- Keep stable map keys unchanged unless replacement is intentional.
- Review force-destroy, deletion protection, retention, and Vault Lock changes
  separately from routine configuration changes.
- Validate with mocked tests first, then use a dedicated sandbox account for
  live integration tests before production adoption.
