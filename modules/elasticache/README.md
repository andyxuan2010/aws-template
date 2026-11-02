# ElastiCache module

Creates a Valkey or Redis OSS replication group and subnet group. The caller
owns the cache client security group, ACL users/user group, IAM, and any
application connection configuration.

## Secure defaults

- Multi-AZ and automatic failover are enabled with at least two cache nodes.
- At-rest and in-transit encryption are mandatory.
- Requires caller-managed ElastiCache user groups. Passwords stay in the
  service-side ACL setup and are not passed through Terraform inputs.
- Requires private subnets and explicit security groups.
- Automatic snapshots are retained for seven days by default.

## Basic usage

```hcl
module "cache" {
  source = "../../modules/elasticache"

  workload          = "session"
  region_code       = "use1"
  environment       = "prod"
  engine            = "valkey"
  engine_version    = "7.2"
  node_type         = "cache.r7g.large"
  subnet_ids        = toset(values(module.vpc.private_subnet_ids))
  security_group_ids = toset([module.cache_sg.security_group_id])
  user_group_ids    = [aws_elasticache_user_group.app.id]
}
```

Choose a currently supported engine version and node type for the target Region.
Engine version, topology, node type, and encryption changes can require
maintenance or replacement. This initial interface supports non-cluster-mode
replication groups.

Common uses include session state, application caching, and read-scaled cache
workloads. Use a separately designed durable database for data that must survive
cache replacement.

## Costs and operations

Cache nodes, backups, data transfer, and customer-managed KMS keys incur cost.
Monitor memory, evictions, replication lag, and failover events.

Configure AWS credentials and provider in the consuming root. Terraform
`>= 1.6.0`, AWS provider `>= 5.83, < 7.0`.

Generated names and tags follow the repository
[naming](../../docs/60-security-governance/naming-convention.md) and
[tagging](../../docs/60-security-governance/tagging-standard.md) standards.

## Terraform Reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.83, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.83, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_engine"></a> [engine](#input\_engine) | Cache engine: valkey or redis. | `string` | `"valkey"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Explicit compatible engine version. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Optional customer-managed KMS key ID or ARN. | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Optional weekly maintenance window. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Replication group identifier; generated when empty. | `string` | `""` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | ElastiCache node type. | `string` | n/a | yes |
| <a name="input_num_cache_clusters"></a> [num\_cache\_clusters](#input\_num\_cache\_clusters) | Number of cache nodes for non-cluster mode. | `number` | `2` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Optional compatible parameter group name. | `string` | `null` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS Region code. | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Caller-managed security group IDs. | `set(string)` | n/a | yes |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | Automatic backup retention days. | `number` | `7` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Private subnet IDs in distinct Availability Zones. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource-specific tags. | `map(string)` | `{}` | no |
| <a name="input_user_group_ids"></a> [user\_group\_ids](#input\_user\_group\_ids) | Caller-managed ElastiCache user group IDs for client authentication. | `set(string)` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_port"></a> [port](#output\_port) | Client port. |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Primary endpoint address. |
| <a name="output_reader_endpoint_address"></a> [reader\_endpoint\_address](#output\_reader\_endpoint\_address) | Reader endpoint address. |
| <a name="output_replication_group_arn"></a> [replication\_group\_arn](#output\_replication\_group\_arn) | ElastiCache replication group ARN. |
| <a name="output_replication_group_id"></a> [replication\_group\_id](#output\_replication\_group\_id) | ElastiCache replication group ID. |
<!-- END_TF_DOCS -->
