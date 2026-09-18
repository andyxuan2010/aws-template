# RDS module

Creates an encrypted RDS instance and DB subnet group. RDS manages the master
password in Secrets Manager; the module intentionally accepts no plaintext
password input.

Secure defaults use private networking, Multi-AZ, 35-day backups, deletion
protection, automated minor upgrades, tag-copying, and a final snapshot.
Production cannot weaken those controls.

```hcl
module "database" {
  source = "../../modules/rds"

  engine                 = "postgres"
  engine_version         = "16.4"
  instance_class         = "db.t4g.small"
  master_username        = "platform_admin"
  region_code            = "use1"
  subnet_ids             = values(module.vpc.private_subnet_ids)
  vpc_security_group_ids = [module.database_sg.security_group_id]
  kms_key_id             = module.kms.key_arn
}
```

Engine versions, log export names, and instance-class capabilities vary by
region. Root compositions must pin combinations validated for their target
region.
## Prerequisites and Dependencies

Configure the AWS provider and credentials in the calling root module. Pass
dependencies through typed inputs and module outputs; this child module does
not configure providers or a backend.

## Important Behavior and Secure Defaults

Review the module defaults, lifecycle implications, replacement behavior, and
AWS service costs before use. Production guardrails fail during planning when
an unsafe combination can be detected statically.

## Naming and Tagging

Generated names and effective tags follow the repository
[naming convention](../../docs/NAMING_CONVENTION.md) and
[tagging standard](../../docs/TAGGING_STANDARD.md). Stable map keys are
Terraform resource identity and should not be renamed casually.

## Testing

`powershell
terraform init -backend=false
terraform validate
terraform test
`

Tests use mocked providers and do not apply AWS resources.

## Known Limitations

The module owns only the resources documented below. Account-level policies,
cross-account trust, service quotas, and live integration verification remain
the responsibility of the calling composition.

## Terraform Reference

The content below is generated from module source. Do not edit it manually.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Initial allocated storage in GiB. | `number` | `20` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Allow major engine upgrades. | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply eligible modifications immediately instead of in the maintenance window. | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Automatically install minor engine upgrades. | `bool` | `true` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Automated backup retention in days. | `number` | `35` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Optional UTC backup window. | `string` | `null` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Optional initial database name. | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Protect the DB instance from deletion. | `bool` | `true` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Engine-supported log types exported to CloudWatch Logs. | `set(string)` | `[]` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | RDS database engine. | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Pinned database engine version. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit resource instance. | `string` | `"001"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | RDS DB instance class. | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Optional customer-managed KMS key ARN or ID. | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Optional UTC maintenance window. | `string` | `null` | no |
| <a name="input_manage_master_user_password"></a> [manage\_master\_user\_password](#input\_manage\_master\_user\_password) | Let RDS manage the master password in Secrets Manager. | `bool` | `true` | no |
| <a name="input_master_user_secret_kms_key_id"></a> [master\_user\_secret\_kms\_key\_id](#input\_master\_user\_secret\_kms\_key\_id) | Optional KMS key for the RDS-managed master-user secret. | `string` | `null` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Master database username. The password is managed by RDS in Secrets Manager. | `string` | n/a | yes |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Storage autoscaling ceiling in GiB. Zero disables autoscaling. | `number` | `100` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Deploy a standby in another Availability Zone. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Explicit DB identifier. When empty, the standard name is generated. | `string` | `""` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Enable Performance Insights when supported by the selected engine and class. | `bool` | `false` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | Optional KMS key for Performance Insights. | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Performance Insights retention in days. | `number` | `7` | no |
| <a name="input_port"></a> [port](#input\_port) | Database listener port. Null uses the engine default. | `number` | `null` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Expose the database publicly. Disabled and prohibited for production. | `bool` | `false` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Skip the final snapshot on deletion. Disabled by default. | `bool` | `false` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Encrypt database storage. | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | RDS storage type. | `string` | `"gp3"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Private subnet IDs for the DB subnet group. | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Database-specific tags. | `map(string)` | `{}` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | Security groups controlling database access. | `set(string)` | n/a | yes |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | Database hostname. |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | RDS DB instance ARN. |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | RDS DB instance ID. |
| <a name="output_db_subnet_group_name"></a> [db\_subnet\_group\_name](#output\_db\_subnet\_group\_name) | DB subnet group name. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Database connection endpoint. |
| <a name="output_master_user_secret_arn"></a> [master\_user\_secret\_arn](#output\_master\_user\_secret\_arn) | ARN of the RDS-managed master-user secret. |
| <a name="output_name"></a> [name](#output\_name) | Resolved DB identifier. |
| <a name="output_port"></a> [port](#output\_port) | Database listener port. |
<!-- END_TF_DOCS -->
