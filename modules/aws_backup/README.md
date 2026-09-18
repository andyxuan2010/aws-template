# AWS Backup

Creates an encrypted backup vault, backup plan, selections, and optional Vault Lock.

## Features

- Customer-managed encryption, scheduled/continuous rules, lifecycle and cross-vault copies.
- Resource or tag-condition selections and optional compliance lock.

## Resources Created

One vault and plan, optional lock, and zero or more selections.

## Prerequisites and Dependencies

Requires a KMS key and least-privilege AWS Backup service roles for selections. Copy destinations must exist.

## Basic Usage

```hcl
module "backup" { source="./modules/aws_backup" region_code="use1" kms_key_arn=module.kms.key_arn }
```

## Important Behavior and Secure Defaults

The default daily rule retains 35 days. Vault force deletion is disabled and prohibited in production. Vault Lock can become irreversible.

## Naming and Tagging

Names and tags follow repository standards.

## Testing

Run backend-free init, validate, and test.

## Known Limitations

Cross-account copy policies and service-role creation are caller-owned to preserve trust boundaries.

## Terraform Reference

Generated from source; do not edit manually.

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
| [aws_backup_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. | `string` | `"dev"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Delete recovery points when destroying the vault. | `bool` | `false` | no |
| <a name="input_inherited_tags"></a> [inherited\_tags](#input\_inherited\_tags) | Canonical enterprise tags. | `map(string)` | `{}` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Three-digit instance. | `string` | `"001"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Customer-managed KMS key ARN for the vault. | `string` | n/a | yes |
| <a name="input_lock_configuration"></a> [lock\_configuration](#input\_lock\_configuration) | Optional Backup Vault Lock configuration. | `object({ min_retention_days = number, max_retention_days = optional(number), changeable_for_days = optional(number) })` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Optional backup plan and vault base name. | `string` | `""` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | Short AWS region code. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Backup rules keyed by stable logical name. | `map(object({ schedule = optional(string, "cron(0 5 ? * * *)"), start_window = optional(number, 60), completion_window = optional(number, 180), enable_continuous_backup = optional(bool, false), lifecycle = optional(object({ cold_storage_after = optional(number), delete_after = number })), copy_actions = optional(list(object({ destination_vault_arn = string, lifecycle = optional(object({ cold_storage_after = optional(number), delete_after = number })) })), []) }))` | <pre>{<br>  "daily": {<br>    "lifecycle": {<br>      "delete_after": 35<br>    }<br>  }<br>}</pre> | no |
| <a name="input_selections"></a> [selections](#input\_selections) | Backup selections keyed by stable logical name. | <pre>map(object({ iam_role_arn = string, resources = optional(set(string), []), not_resources = optional(set(string), []), conditions = optional(list(object({ type = string, key = string<br>  value = string })), []) }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Backup-specific tags. | `map(string)` | `{}` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload identifier. | `string` | `"platform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_plan_arn"></a> [plan\_arn](#output\_plan\_arn) | Backup plan ARN. |
| <a name="output_plan_id"></a> [plan\_id](#output\_plan\_id) | Backup plan ID. |
| <a name="output_selection_ids"></a> [selection\_ids](#output\_selection\_ids) | Selection IDs keyed by input key. |
| <a name="output_tags"></a> [tags](#output\_tags) | Effective tags. |
| <a name="output_vault_arn"></a> [vault\_arn](#output\_vault\_arn) | Backup vault ARN. |
| <a name="output_vault_id"></a> [vault\_id](#output\_vault\_id) | Backup vault ID. |
<!-- END_TF_DOCS -->
